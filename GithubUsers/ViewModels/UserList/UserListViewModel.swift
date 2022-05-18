// 
//  UserListViewModel.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/8.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Prototype

protocol UserListViewModelInput {
    func filterUser(_ name: String)
}

protocol UserListViewModelOutput {
    var models: Observable<[UserModel]> { get }
    var searchResult: Observable<[UserModel]> { get }
}

protocol UserListViewModelPrototype {
    var input: UserListViewModelInput { get }
    var output: UserListViewModelOutput { get }
}

// MARK: - View model

class UserListViewModel: UserListViewModelPrototype {
    
    var input: UserListViewModelInput { self }
    var output: UserListViewModelOutput { self }

    init(userListAPI: UserListAPIPrototype?) {
        
        self.userListAPI = userListAPI
        
        guard let userListAPI = self.userListAPI else {
            return
        }
        
        bind(userListAPI: userListAPI)
    }
    
    private let userListAPI: UserListAPIPrototype?
    private let userList = BehaviorRelay<[UserModel]>(value: [])
    private let searchList = BehaviorRelay<[UserModel]>(value: [])
    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension UserListViewModel: UserListViewModelInput {
    func filterUser(_ name: String) {
        if name.count == 0 {
            searchList.accept(userList.value)
        } else {
            let filterList = userList.value.filter {
                guard let userName = $0.login else { return false }
                return userName.uppercased().contains(name.uppercased())
            }
            searchList.accept(filterList)
        }
    }
}

extension UserListViewModel: UserListViewModelOutput {
    
    var models: Observable<[UserModel]> {
        userList.compactMap { $0 }.asObservable()
    }
    
    var searchResult: Observable<[UserModel]> {
        searchList.compactMap { $0 }.asObservable()
    }
}

// MARK: - Private function

private extension UserListViewModel {
    func bind(userListAPI: UserListAPIPrototype) {

        userListAPI
            .result
            .withUnretained(self)
            .subscribe(onNext: { owner, list in
                owner.userList.accept(list)
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
