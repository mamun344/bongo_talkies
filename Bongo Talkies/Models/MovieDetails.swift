//
//  MovieDetails.swift
//  Bongo Talkies
//
//  Created by Admin on 5/11/22.
//

import Foundation

class MovieDetails: CodableModel {

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

    let budget: Double?
    let homepage: String?
    let imdbId: String?
    let overview: String?
    let revenue: Double?
    let runtime: Double?
    let status: String?
    let tagLine: String?
    let genres : [MovieGenres]?
    let productionCompanies : [ProductionCompany]?
    let productionCountries : [ProductionCountry]?
    let spokenLanguages : [SpokenLanguage]?
    
    

    lazy var averageVoteRounded: String? = {
        if let averageVote {
            return String(format: "%0.1lf", Double(Int(averageVote * 10)) / 10.0)
        }
        else {
            return nil
        }
    }()
    
    lazy var runTimeString: String? = {
        if let runtime {
            let mins = Int(runtime)
            
            return "\(mins / 60):\(mins % 60) Hours"
        }
        else {
            return nil
        }
    }()
    
    lazy var releaseDate: Date? = {
        if let releaseDateString, releaseDateString.count > 0 {
            return releaseDateString.convertToDate("yyyy-MM-dd", utc: true)
        }
        else {
            return nil
        }
    }()
    
    lazy var releaseDateFormattedString: String? = {
        if let releaseDate {
            return releaseDate.convertToString(format: "dd MMM, yyyy", local: true)
        }
        else {
            return nil
        }
    }()

    lazy var formattedBudget: String? = {
        if let budget {
            return budget.formatPoints()
        }
        else {
            return nil
        }
    }()
    
    lazy var formattedRevenue: String? = {
        if let revenue {
            return revenue.formatPoints()
        }
        else {
            return nil
        }
    }()
    
  
    
    
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

        case budget = "budget"
        case homepage = "homepage"
        case imdbId = "imdb_id"
        case overview = "overview"
        case revenue = "revenue"
        case runtime = "runtime"
        case status = "status"
        case tagLine = "tagline"
        case genres = "genres"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
    }
    
    init(movie: Movie) {
        id = movie.id
        poster = movie.poster
        isAdult = movie.isAdult
        releaseDateString = movie.releaseDateString
        title = movie.title
        language = movie.language
        backdrop = movie.backdrop
        popularity = movie.popularity
        totalVote = movie.totalVote
        averageVote = movie.averageVote
        
        budget = nil
        homepage = nil
        imdbId = nil
        overview = nil
        revenue = nil
        runtime = nil
        status = nil
        tagLine = nil
        genres = nil
        productionCompanies = nil
        productionCountries = nil
        spokenLanguages = nil
    }
}


