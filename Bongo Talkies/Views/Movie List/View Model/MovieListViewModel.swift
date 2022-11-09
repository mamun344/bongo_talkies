//
//  MovieListViewModel.swift
//  Bongo Talkies
//
//  Created by Admin on 6/11/22.
//

import UIKit

final class MovieListViewModel: ObservableObject {
    
    private let apiService      : APIService
    
    @Published var movies       : [Movie] = []
    @Published var fetchedOnce  : Bool = false
    @Published var isLoading    : Bool = false
    @Published var hasInternet  : Bool = true
    @Published var showAlert    : Bool = false
    @Published var alertMessage : String = ""
    @Published var errorMessage : String? = nil

    
    var currentPage             : Int = 1
    var totalPage               : Int = 1
    var selectedIndex           : Int = -1
    
    
    var selectedMovie: Movie? {
        (selectedIndex >= 0 && selectedIndex < movies.count) ? movies[selectedIndex] : nil
    }
       
    
    init(apiService: APIService){
        self.apiService = apiService
    }
    
    
    func refresh(internet: Bool, onComplete: (()->())? = nil){
        print("refresh \(internet)")
        
        hasInternet = internet
        guard isLoading == false, movies.isEmpty else {
            onComplete?()
            return
        }

        if hasInternet {
            loadPageWiseMovies(onComplete: onComplete)
        }
        else if movies.isEmpty {
            errorMessage = Titles.noInternet
            onComplete?()
        }
        else {
            onComplete?()
        }
    }
    
    func loadNextPageIfPossible(_ movie: Movie, onComplete: (()->())? = nil){
        guard isLoading == false, totalPage > currentPage else {
            onComplete?()
            return
        }
        
        if hasInternet {
            if movies.isThresholdItem(offset: 4, item: movie) {
                currentPage += 1
                loadPageWiseMovies(onComplete: onComplete)
            }
            else {
                onComplete?()
            }
        }
        else if movies.isEmpty {
            errorMessage = Titles.noInternet
            onComplete?()
        }
        else {
            onComplete?()
        }
    }
    
    
    private func loadPageWiseMovies(onComplete: (()->())? = nil){
        self.isLoading = true

        apiService.fetchTopMovies(page: currentPage) { [weak self] (response) in
            guard let strongSelf = self else { return }

            DispatchQueue.main.async {
                strongSelf.isLoading = false
                
                switch response {
                case .success(let list):
                    if let movies = list.movies {
                        strongSelf.fetchedOnce = true
                        
                        if strongSelf.movies.isEmpty {
                            strongSelf.totalPage = list.totalPages ?? strongSelf.currentPage
                        }
                        
                        strongSelf.movies += movies
                    }
                                        
                case .failure(let error):
                    if strongSelf.movies.isEmpty {
                        strongSelf.errorMessage = error.description
                    }
                    else {
                        strongSelf.alertMessage = error.description
                        strongSelf.showAlert = true
                    }
                }
                
                onComplete?()
            }
        }
    }
}
