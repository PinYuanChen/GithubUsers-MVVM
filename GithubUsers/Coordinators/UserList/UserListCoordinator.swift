// 
//  UserListCoordinator.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/8.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Reaction
enum UserListCoordinatorReaction {
    case changeTab
}

class UserListCoordinator: Coordinator<Void> {
    
    let reaction = PublishRelay<UserListCoordinatorReaction>()

    override func start() {
        let vc = UserListViewController()
        rootViewController = vc
        
        navigationController = UINavigationController(rootViewController: vc)
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let vm = UserListViewModel(userListAPI: UserListAPI())
        vc.viewModel = vm
        
        vm
            .reaction
            .subscribe(onNext: { [weak self] reaction in
                guard let self = self else { return }
                switch reaction {
                case .showUserDetail(username: let username):
                    self.showUserDetail(username: username)
                case .changeTab:
                    self.reaction.accept(.changeTab)
                }
            })
            .disposed(by: disposeBag)
    }

    override func stop() {
    }
    
}

private extension UserListCoordinator {
    
    func showUserDetail(username: String) {
        let next = UserDetailCoordinator(username: username)
        next.start()
        store(coordinator: next)
        presentCoordinator(coordinator: next)
    }
    
}
