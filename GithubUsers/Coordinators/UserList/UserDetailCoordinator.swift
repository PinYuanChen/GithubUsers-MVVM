// 
//  UserDetailCoordinator.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/9.
//

import Foundation
import RxSwift
import RxCocoa

class UserDetailCoordinator: Coordinator<Void> {

    init(username: String) {
        self.username = username
    }
    
    override func start() {
        let vc = UserDetailViewController()
        rootViewController = vc
        
        let vm = UserDetailViewModel(username: username, userDetailAPI: UserDetailAPI())
        vc.viewModel = vm
        
        vm
            .reaction
            .subscribe(onNext: { reaction in
                switch reaction {
                case .dismiss:
                    vc.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }

    override func stop() {
    }
    
    private let username: String
}
