//
//  MovieAPIServiceMock.swift
//  Bongo TalkiesTests
//
//  Created by Admin on 9/11/22.
//

import Foundation


class MovieAPIServiceMock : APIService {
    var mockData: Data?
    var error: ResponseError?
    
    init(mockData: Data?) {
        self.mockData = mockData
    }
    
    func fetchTopMovies(page: Int, onComplete: @escaping (Result<MovieList, ResponseError>) -> Void) {
        if let error {
            onComplete(.failure(error))
        }
        else if let mockData {
            if let movieList = MovieList.fromJSON(mockData) {
                onComplete(.success(movieList))
            }
            else {
                onComplete(.failure(.jsonParseFailed))
            }
        }
        else {
            onComplete(.failure(.noResponse))
        }
    }
    
    func fetchMovieDetails(id: Int, onComplete: @escaping (Result<MovieDetails, ResponseError>) -> Void) {
        if let error {
            onComplete(.failure(error))
        }
        else if let mockData {
            if let details = MovieDetails.fromJSON(mockData) {
                onComplete(.success(details))
            }
            else {
                onComplete(.failure(.jsonParseFailed))
            }
        }
        else {
            onComplete(.failure(.noResponse))
        }
    }
}
