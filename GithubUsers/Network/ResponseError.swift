//
//  ResponseError.swift
//  TravelAlbum
//
//  Created by PatrickChen on 2021/12/5.
//

import Foundation

enum ResponseError: Error {

    static var defaultErrorMessage: String {
        "伺服器忙碌中，請稍後再嘗試，或與客服人員聯繫"
    }

    enum APIError: Int, Error {
        case forbidden = 403
        case notFound = 404
        case systemBusy = 500
    }

    case parseError(error: Error)
    case apiError(error: APIError)
    case unknownAPIError(statusCode: Int)
    case unknownError(error: Error)
}

extension ResponseError.APIError {

    var message: String {
        switch self {
        case .forbidden:
            return "您的網路位置疑似被禁止訪問"
        case .notFound:
            return "伺服器異常，請稍後再嘗試"
        case .systemBusy:
            return ResponseError.defaultErrorMessage
        }
    }
}

extension ResponseError {

    var message: String {

        switch self {
        case .parseError(error: let error):
            return .init(
                format: "%@\n%@",
                Self.defaultErrorMessage,
                "\(error)"
            )

        case .apiError(error: let error):
            return error.message

        case .unknownAPIError(statusCode: let statusCode):
            return .init(
                format: "%@\n%@%d",
                Self.defaultErrorMessage,
                "未知 statusCode: ",
                statusCode
            )

        case .unknownError(error: let error):
            return .init(
                format: "%@\n%@",
                Self.defaultErrorMessage,
                "未知 error: \(error)"
            )
        }
    }
}
