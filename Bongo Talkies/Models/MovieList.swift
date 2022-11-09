//
//  MovieList.swift
//  Bongo Talkies
//
//  Created by Admin on 4/11/22.
//

import Foundation


struct MovieList : CodableModel {
    let currentPage: Int?
    let totalPages: Int?
    let movies: [Movie]?
        
   public enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPages = "total_pages"
        case movies = "results"
    }
}



