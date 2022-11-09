//
//  ProductionCompany.swift
//  Bongo Talkies
//
//  Created by Admin on 5/11/22.
//

import Foundation

struct ProductionCompany: CodableModel  {
    let id : Int
    let name : String?
    let path : String?
    let country : String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case path = "logo_path"
        case country = "origin_country"
    }
}
