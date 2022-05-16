// 
//  UserDetailViewModel.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/9.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Reaction

enum UserDetailViewModelReaction {
    case dismiss
}

// MARK: - Prototype

protocol UserDetailViewModelInput {
    func dismiss()
}

protocol UserDetailViewModelOutput {
    var userModel: Observable<PersonalInfoModel> { get }
}

protocol UserDetailViewModelPrototype {
    var input: UserDetailViewModelInput { get }
    var output: UserDetailViewModelOutput { get }
}

// MARK: - View model

class UserDetailViewModel: UserDetailViewModelPrototype {

    var input: UserDetailViewModelInput { self }
    var output: UserDetailViewModelOutput { self }
    let reaction = PublishRelay<UserDetailViewModelReaction>()
    
    init(username: String, userDetailAPI: UserDetailAPIPrototype?) {
        
        self.userDetailAPI = userDetailAPI
        self.username = username
        guard let userDetailAPI = self.userDetailAPI else {
            return
        }
        
        bind(userDetailAPI: userDetailAPI)
    }
    
    private let userDetailAPI: UserDetailAPIPrototype?
    private let _userModel = BehaviorRelay<PersonalInfoModel?>(value: nil)
    private let username: String
    private let disposeBag = DisposeBag()
}

// MARK: - Input & Output

extension UserDetailViewModel: UserDetailViewModelInput {
    func dismiss() {
        reaction.accept(.dismiss)
    }
}

extension UserDetailViewModel: UserDetailViewModelOutput {
    var userModel: Observable<PersonalInfoModel> {
        _userModel.compactMap{ $0 }.asObservable()
    }
}

// MARK: - Private function

private extension UserDetailViewModel {

    func bind(userDetailAPI: UserDetailAPIPrototype) {
        
        userDetailAPI
            .result
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self._userModel.accept(model)
            })
            .disposed(by: disposeBag)
        
        userDetailAPI
            .error
            .subscribe(onNext: { error in
                print("\(error)")
            })
            .disposed(by: disposeBag)
        
        userDetailAPI.fetch(username: username)
    }
    
}
