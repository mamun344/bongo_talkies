//
//  MovieDetailsViewModel.swift
//  Bongo Talkies
//
//  Created by Admin on 7/11/22.
//

import UIKit

final class MovieDetailsViewModel: ObservableObject {
    
    private let apiService      : APIService
    private let movie           : Movie

    @Published var isLoading    : Bool = false
    @Published var alertMessage : String = ""
    @Published var showAlert    : Bool = false
    @Published var gotDetails   : Bool = false

    @Published var movieDetails: MovieDetails


    var businessInfo : [String] {
        var info = [String]()
        if let budget = movieDetails.formattedBudget {  info.append("Budget : $\(budget)") }
        if let revenue = movieDetails.formattedRevenue {  info.append("Revenue : $\(revenue)") }
        return info
    }

    var languages : [String] {
        if let langs = movieDetails.spokenLanguages, langs.count > 0 {
            return langs.compactMap { $0.englishName == nil ? nil : $0.englishName! }
        }
        return []
    }
    
    var genres : [String] {
        if let genres = movieDetails.genres, genres.count > 0 {
            return genres.compactMap { $0.name == nil ? nil : $0.name! }
        }
        return []
    }
    
    var companies : [String] {
        if let companies = movieDetails.productionCompanies, companies.count > 0 {
            return companies.compactMap { $0.name == nil ? nil : $0.name! }
        }
        return []
    }
    
    var countries : [String] {
        if let countries = movieDetails.productionCountries, countries.count > 0 {
            return countries.compactMap { $0.name }
        }
        return []
    }
     
    
    init(movie: Movie, apiService: APIService){
        self.movie = movie
        movieDetails = MovieDetails(movie: movie)
        self.apiService = apiService
    }
 
    
    func refresh(internet: Bool, onComplete: (()->())? = nil){        
        guard isLoading == false, gotDetails == false, internet else {
            onComplete?()
            return
        }

        self.isLoading = true
        
        apiService.fetchMovieDetails(id: movie.id) { [weak self] (response) in
            guard let strongSelf = self else { return }
           
            DispatchQueue.main.async {
                strongSelf.isLoading = false
                
                switch response {
                case .success(let details):
                    strongSelf.gotDetails = true
                    strongSelf.movieDetails = details

                case .failure(let error):
                    strongSelf.alertMessage = error.description
                    strongSelf.showAlert = true
                }
                                
                onComplete?()
            }
        }
    }
}
