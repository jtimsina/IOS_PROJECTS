//
//  Movie.swift
//  Movies
//
//  Created by Christian Quicano on 23/08/21.
//

import Foundation

struct Movie: Decodable {
    let identifier: Int
    let overview: String
    let originalTitle: String
    let posterPath: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case overview
        case originalTitle = "original_title"
        case posterPath = "poster_path"
    }
}
