//
//  Decision.swift
//  TravelAlbum
//
//  Created by PatrickChen on 2021/12/5.
//

import Foundation
import Moya
import RxSwift
import RxCocoa

enum DecisionAction<T: TATargetType> {
    case continueWith(response: Moya.Response)
    case restartWith(decisions: [Decision])
    case errored(error: ResponseError)
    case done(value: T.ResponseType)
}

protocol Decision {

    func shouldApply<T: TATargetType>(
        request: T,
        response: Moya.Response
    ) -> Bool

    func apply<T: TATargetType>(
        request: T,
        response: Moya.Response,
        done closure: @escaping (DecisionAction<T>) -> Void
    )
}

fileprivate let decoder = JSONDecoder()

struct ResponseStatusCodeDecision: Decision {

    enum ServiceError: Error {
        case error(code: Int)
    }

    func shouldApply<T: TATargetType>(
        request: T,
        response: Moya.Response
    ) -> Bool {
        return !(200 ..< 300).contains(response.statusCode)
    }

    func apply<T: TATargetType>(
        request: T,
        response: Moya.Response,
        done closure: @escaping (DecisionAction<T>) -> Void
    ) {

        let statusCode = response.statusCode

        guard let apiError = ResponseError.APIError(rawValue: statusCode) else {
            closure(.errored(error: .unknownAPIError(statusCode: statusCode)))
            return
        }

        closure(.errored(error: .apiError(error: apiError)))
    }
}

struct ParseResultDecision: Decision {

    func shouldApply<T: TATargetType>(
        request: T,
        response: Moya.Response
    ) -> Bool { true }

    func apply<T: TATargetType>(
        request: T,
        response: Moya.Response,
        done closure: @escaping (DecisionAction<T>) -> Void
    ) {

        do {
            let responseData = try decoder.decode(T.ResponseType.self, from: response.data)
            closure(.done(value: responseData))
        } catch {
            closure(.errored(error: .parseError(error: error)))
        }
    }
}
