//
//  NetworkError.swift
//  Movies
//
//  Created by Christian Quicano on 23/08/21.
//

import Foundation

enum NetworkError: Error {
    case url
    case other(Error)
    case serverError
}
