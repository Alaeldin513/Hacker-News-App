//
//  WebServiceManagerErrors.swift
//  Hacker News App
//
//  Created by Alaeldin Tirba on 2/15/19.
//  Copyright © 2019 Alaeldin Tirba. All rights reserved.
//

import Foundation


enum HackerNewsAPIError: Error {
    case noNetworkConnectionFound
    case invalidJSONRequest
    case invalidJSONResponse
    case permissionDenied
    case genericServerError(Int, String)
    
}

extension HackerNewsAPIError: LocalizedError {
    var errorDescription: String? {
        var description: String? = .none
        switch self {
        case .noNetworkConnectionFound:
            description = "Your internet connection appears to be offline."
        case .permissionDenied:
            description = "The user does not have permission to access this feature."
        case .invalidJSONResponse:
            description = "Json Data is Corrupt"
        case .genericServerError(_, let message):
            description = message
        default:
            break
        }
        return description
    }
}
