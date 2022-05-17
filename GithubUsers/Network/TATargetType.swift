//
//  TATargetType.swift
//  TravelAlbum
//
//  Created by PatrickChen on 2021/12/5.
//

import Foundation
import Moya

protocol DecodableResponseTargetType: TargetType {

  associatedtype ResponseType: Codable
}

protocol TATargetType: DecodableResponseTargetType {

    var decisions: [Decision] { get }
}

extension TATargetType {

    var baseURL: URL {
        guard let url = URL(string: "https://api.github.com/") else {
            assert(false)
        }
        return url
    }

    var headers: [String: String]? {
        ["accept": "application/json"]
    }

    var decisions: [Decision] {
        [
            ResponseStatusCodeDecision(),
            ParseResultDecision(),
        ]
    }
}
