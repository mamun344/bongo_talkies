//
//  ProductionCountry.swift
//  Bongo Talkies
//
//  Created by Admin on 5/11/22.
//

import Foundation

struct ProductionCountry: CodableModel  {
    let iso : String
    let name : String

    enum CodingKeys: String, CodingKey {
        case iso = "iso_3166_1"
        case name
    }
}
