// 
//  UserListViewModel.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/8.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Reaction

enum UserListViewModelReaction {
    case showUserDetail(username: String)
    case changeTab
}


// MARK: - Prototype

protocol UserListViewModelInput {
    func showUserDetailInfo(username: String)
    func changeSelectedTab()
}

protocol UserListViewModelOutput {
    var models: Observable<[UserModel]> { get }
}

protocol UserListViewModelPrototype {
    var input: UserListViewModelInput { get }
    var output: UserListViewModelOutput { get }
}

// MARK: - View model

class UserListViewModel: UserListViewModelPrototype {

    var input: UserListViewModelInput { self }
    var output: UserListViewModelOutput { self }
    let reaction = PublishRelay<UserListViewModelReaction>()

    init(userListAPI: UserListAPIPrototype?) {
        
        self.userListAPI = userListAPI
        
        guard let userListAPI = self.userListAPI else {
            return
        }
        
        bind(userListAPI: userListAPI)
    }
    
    private let userListAPI: UserListAPIPrototype?
    private let userList = BehaviorRelay<[UserModel]>(value: [])
    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension UserListViewModel: UserListViewModelInput {
    
    func showUserDetailInfo(username: String) {
        self.reaction.accept(.showUserDetail(username: username))
    }
    
    func changeSelectedTab() {
        self.reaction.accept(.changeTab)
    }
    
}

extension UserListViewModel: UserListViewModelOutput {
    
    var models: Observable<[UserModel]> {
        userList.compactMap { $0 }.asObservable()
    }
}

// MARK: - Private function

private extension UserListViewModel {
    func bind(userListAPI: UserListAPIPrototype) {

        userListAPI
            .result
            .subscribe(onNext: { [weak self] list in
                guard let self = self else { return }
                self.userList.accept(list)
            })
            .disposed(by: disposeBag)
        
        userListAPI
            .error
            .subscribe(onNext: { error in
                print("\(error)")
            })
            .disposed(by: disposeBag)

        userListAPI.fetch()
        
    }
}
