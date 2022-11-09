//
//  SpokenLanguage.swift
//  Bongo Talkies
//
//  Created by Admin on 5/11/22.
//

import Foundation

struct SpokenLanguage: CodableModel  {
    let name : String
    let englishName : String?
    let iso : String?

    enum CodingKeys: String, CodingKey {
        case name
        case englishName = "english_name"
        case iso = "iso_639_1"
    }
}

