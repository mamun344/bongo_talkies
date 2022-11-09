//
//  Movie.swift
//  Bongo Talkies
//
//  Created by Admin on 4/11/22.
//

import Foundation

struct Movie : CodableModel, Hashable, Identifiable {
    
    let id: Int
    let poster: String?
    let isAdult: Bool?
    let releaseDateString: String?
    let title: String?
    let language: String?
    let backdrop: String?
    let popularity: Double?
    let totalVote: Int?
    let averageVote: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case poster = "poster_path"
        case isAdult = "adult"
        case releaseDateString = "release_date"
        case title
        case language = "original_language"
        case backdrop = "backdrop_path"
        case popularity
        case totalVote = "vote_count"
        case averageVote = "vote_average"
    }
}






