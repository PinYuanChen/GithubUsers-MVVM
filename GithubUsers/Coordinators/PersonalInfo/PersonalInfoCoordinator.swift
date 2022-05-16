// 
//  PersonalInfoCoordinator.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/8.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - Reaction
enum PersonalInfoCoordinatorReaction {
    case changeTab
}

class PersonalInfoCoordinator: Coordinator<Void> {

    let reaction = PublishRelay<PersonalInfoViewModelReaction>()
    
    override func start() {
        
        let vc = PersonalInfoViewController()
        rootViewController = vc
        
        navigationController = UINavigationController(rootViewController: vc)
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let vm = PersonalInfoViewModel(api: PersonalInfoAPI())
        
        vm
            .reaction
            .subscribe(onNext: { [weak self] reaction in
                
                guard let self = self else { return }

                switch reaction {
                case .changeTab:
                    self.reaction.accept(reaction)
                }
                
            })
            .disposed(by: disposeBag)
        
        vc.viewModel = vm
        
    }

    override func stop() {
    }
    
}
