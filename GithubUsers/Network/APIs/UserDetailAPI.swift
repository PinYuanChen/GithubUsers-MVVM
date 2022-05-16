//
//  UserDetailAPI.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/9.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

private struct RequestTargetType: TATargetType {

    typealias ResponseType = PersonalInfoModel

    var username: String
    
    var path: String {
        username
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        .requestPlain
    }
}

protocol UserDetailAPIPrototype {

    var result: Observable<PersonalInfoModel> { get }
    
    var error: Observable<ResponseError> { get }
    
    func fetch(username: String)
}

struct UserDetailAPI: UserDetailAPIPrototype {

    var result: Observable<PersonalInfoModel> { _result.asObservable() }
    var error: Observable<ResponseError> { _error.asObservable() }

    func fetch(username: String) {
        MoyaProvider<RequestTargetType>().send(
            request: RequestTargetType(username: username)
        ) {
            switch $0 {
            case .success(let model):
                self._result.accept(model)
            case .failure(let error):
                print("🛠 \(#fileID) API Error: ", error)
                let error = error as? ResponseError ?? .unknownError(error: error)
                self._error.accept(error)
            }
        }
    }

    private let _result = PublishRelay<PersonalInfoModel>()
    private let _error = PublishRelay<ResponseError>()
}
