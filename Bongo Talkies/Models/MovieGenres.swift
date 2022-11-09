//
//  MovieGenres.swift
//  Bongo Talkies
//
//  Created by Admin on 5/11/22.
//

import Foundation

struct MovieGenres: CodableModel  {
    let id : Int
    let name : String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
