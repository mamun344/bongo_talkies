//
//  APIService.swift
//  Bongo Talkies
//
//  Created by Admin on 9/11/22.
//

import Foundation


protocol APIService {
    
    func fetchTopMovies(page: Int, onComplete: @escaping (Result<MovieList, ResponseError>)->Void)
    
    func fetchMovieDetails(id: Int, onComplete: @escaping (Result<MovieDetails, ResponseError>)->Void)
}
