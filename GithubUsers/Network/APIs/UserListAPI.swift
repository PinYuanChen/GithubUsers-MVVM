//
//  UserListAPI.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/7.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

private struct RequestTargetType: TATargetType {

    typealias ResponseType = [UserModel]

    var path: String {
        ""
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        .requestPlain
    }
}

protocol UserListAPIPrototype {

    var result: Observable<[UserModel]> { get }
    
    var error: Observable<ResponseError> { get }
    
    func fetch()
}

struct UserListAPI: UserListAPIPrototype {

    var result: Observable<[UserModel]> { _result.asObservable() }
    var error: Observable<ResponseError> { _error.asObservable() }

    func fetch() {
        MoyaProvider<RequestTargetType>().send(
            request: RequestTargetType()
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

    private let _result = PublishRelay<[UserModel]>()
    private let _error = PublishRelay<ResponseError>()
}
