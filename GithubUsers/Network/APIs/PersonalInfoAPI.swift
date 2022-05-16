//
//  PersonalInfoAPI.swift
//  GithubUsers
//
//  Created by PatrickChen on 2021/12/7.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

private struct RequestTargetType: TATargetType {

    typealias ResponseType = PersonalInfoModel

    // Parameters
    let username: String?

    var path: String {
        guard let username = username else { return "" }
        return "/" + username
    }

    var method: Moya.Method {
        .get
    }

    var task: Task {
        .requestPlain
    }
}

protocol PersonalInfoAPIPrototype {

    var result: Observable<PersonalInfoModel> { get }
    
    var error: Observable<ResponseError> { get }

    func get(name: String)
}

struct PersonalInfoAPI: PersonalInfoAPIPrototype {

    var result: Observable<PersonalInfoModel> { _result.asObservable() }
    var error: Observable<ResponseError> { _error.asObservable() }

    func get(name: String) {
        send(name: name)
    }

    private func send(name: String?) {
        MoyaProvider<RequestTargetType>().send(
            request: RequestTargetType(username: name)
        ) {
            switch $0 {
            case .success(let model):
                self._result.accept(model)
            case .failure(let error):
                print("🛠 API Error: ", error)
                let error = error as? ResponseError ?? .unknownError(error: error)
                self._error.accept(error)
            }
        }
    }

    private let _result = PublishRelay<PersonalInfoModel>()
    private let _error = PublishRelay<ResponseError>()
}
