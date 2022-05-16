// 
//  MainTabBarCoordinator.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/8.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Tab bar item
enum TabBarItem: Int, CaseIterable {
    
    case userList = 0
    case personalInfo
    
    var title: String {
        switch self {
        case .userList:
            return "User"
        case .personalInfo:
            return "Mine"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .userList:
            return UIImage(named: "list")
        case .personalInfo:
            return UIImage(named: "person")
        }
    }
}


class MainTabBarCoordinator: Coordinator<Void> {

    // MARK: Properties
    var tabBarController: UITabBarController? {
        rootViewController as? UITabBarController
    }
    
    // MARK: Life cycle
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        
        let tabBarCoordinators = setupCoordinators()
        tabBarCoordinators.forEach {
            $0.start()
            store(coordinator: $0)
        }
        setupTabBarItem(by: tabBarCoordinators)
        
        let tabBarController = createTabBarController(by: tabBarCoordinators)
        rootViewController = tabBarController
        window.rootViewController = rootViewController
    }
    
    // MARK: Private
    private let window: UIWindow
}

// MARK: - Tab bar

private extension MainTabBarCoordinator {
    
    func createTabBarItem(from item: TabBarItem) -> UITabBarItem {
        .init(title: item.title, image: item.image, tag: item.rawValue)
    }
    
    // set up coordinators for each tab
    func setupCoordinators() -> [CoordinatorPrototype] {
        var coordinators = [CoordinatorPrototype]()
        
        TabBarItem.allCases.forEach {
            
            let coordinator: CoordinatorPrototype
            
            switch $0 {
            case .userList:
                
                let tab = UserListCoordinator()
                
                tab
                    .reaction
                    .subscribe(onNext: { [weak self] reaction in
                        
                        guard let self = self else { return }
                        
                        switch reaction {
                        case .changeTab:
                            self.tabBarController?.selectedIndex = 1
                        }
                        
                    })
                    .disposed(by: disposeBag)
                
                coordinator = tab
                
            case .personalInfo:

                let tab = PersonalInfoCoordinator()
                
                tab
                    .reaction
                    .subscribe(onNext: { [weak self] reaction in
                        
                        guard let self = self else { return }
                        
                        switch reaction {
                        case .changeTab:
                            self.tabBarController?.selectedIndex = 0
                        }
                        
                    })
                    .disposed(by: disposeBag)
                
                coordinator = tab
            }
            
            coordinators.append(coordinator)
        }
        
        return coordinators
    }
    
    // setup tab bar item for each vc
    func setupTabBarItem(by coordinators: [CoordinatorPrototype]) {
        for (idx, coord) in coordinators.enumerated() {
            if let item = TabBarItem(rawValue: idx) {
                coord.rootViewController?.tabBarItem = createTabBarItem(from: item)
            }
        }
    }
    
    func createTabBarController(by coords: [CoordinatorPrototype]) -> UITabBarController {
        
        let tabBarController = UITabBarController()
        // check if nav exists
        let vcs = coords.compactMap {
            $0.navigationController != nil ? $0.navigationController : $0.rootViewController
        }

        tabBarController.setViewControllers(vcs, animated: true)
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = .white

        return tabBarController
    }
}
