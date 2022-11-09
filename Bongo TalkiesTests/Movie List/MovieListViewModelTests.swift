//
//  MovieListViewModelTests.swift
//  Bongo TalkiesTests
//
//  Created by Admin on 8/11/22.
//

import XCTest
@testable import Bongo_Talkies

final class MovieListViewModelTests: XCTestCase {
    
    var sut: MovieListViewModel!
    var service: MovieAPIServiceMock!
    

    override func setUpWithError() throws {
        try super.setUpWithError()
        service = MovieAPIServiceMock(mockData: nil)
        sut = MovieListViewModel(apiService: service)
    }

    override func tearDownWithError() throws {
        sut = nil
        service = nil
        try super.tearDownWithError()
    }
    
    func test_MovieList_With_NoData_ErrorResponse() throws {
        service.mockData = nil
        service.error = .noResponse
        
        sut.movies = []
        sut.isLoading = false
        
        let expectation = XCTestExpectation(description: "response")

        sut.refresh(internet: true) {
            XCTAssertEqual(self.sut.movies.count, 0, "Should not get any movie")
            XCTAssertEqual(self.sut.isLoading, false, "Loader should hide")
            XCTAssertEqual(self.sut.errorMessage ?? "", ResponseError.noResponse.description, "Must show no response error")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
   
    func test_MovieList_With_Data_ErrorResponse() throws {
        service.mockData = nil
        service.error = .invalidUrl
        
        let modelData: Data? = "movie_list_valid".fileJSONData()
        XCTAssertNotNil(modelData, "Invalid file")
        
        let modelDataList = MovieList.fromJSON(modelData)
        XCTAssertNotNil(modelDataList, "Invalid JSON Data")
        
        let movies = modelDataList?.movies ?? []
        
        sut.movies = movies
        sut.isLoading = false
        
        let expectation = XCTestExpectation(description: "response")
        
        sut.refresh(internet: true) {
            XCTAssertEqual(self.sut.movies.count, 3, "Should have 3 movie")
            XCTAssertEqual(self.sut.isLoading, false, "Loader should hide")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    
   
    func test_MovieList_With_Initial_Data_NoError() throws {
        let mockData: Data? = "movie_list_valid".fileJSONData()
        XCTAssertNotNil(mockData, "Invalid file")

        service.mockData = mockData
        service.error = nil
        
        sut.movies = []
        sut.isLoading = false
        
        let expectation = XCTestExpectation(description: "response")

        sut.refresh(internet: true) {
            XCTAssertEqual(self.sut.movies.count, 3, "Should fetch 3 movies")
            XCTAssertEqual(self.sut.currentPage, 1, "Current page should be 1")
            XCTAssertEqual(self.sut.totalPage, 100, "Current pages should be 100")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
   
    func test_MovieList_With_Paging_Data_NoError() throws {
        let mockData: Data? = "movie_list_valid".fileJSONData()
        XCTAssertNotNil(mockData, "Invalid file")

        service.mockData = mockData
        service.error = nil
        
        let modelData: Data? = "movie_list_long_valid".fileJSONData()
        XCTAssertNotNil(modelData, "Invalid file")

        let modelDataList = MovieList.fromJSON(modelData)
        XCTAssertNotNil(modelDataList, "Invalid JSON Data")
        
        let movies = modelDataList?.movies ?? []
        sut.movies = movies
        sut.currentPage = 1
        sut.totalPage = 100
        sut.isLoading = false
        
        let expectation = XCTestExpectation(description: "response")

        sut.loadNextPageIfPossible(movies[0]) {
            XCTAssertEqual(self.sut.movies.count, 8, "Should fetch 5 movies and append with previous 3 movies")
            XCTAssertEqual(self.sut.currentPage, 2, "Current page should be 2")
            XCTAssertEqual(self.sut.totalPage, 100, "Should not be change total Page. Should be 100")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
   
    func test_MovieList_With_Paging_Complete() throws {
        let mockData: Data? = "movie_list_valid".fileJSONData()
        XCTAssertNotNil(mockData, "Invalid file")

        service.mockData = mockData
        service.error = nil
        
        let modelData: Data? = "movie_list_long_valid".fileJSONData()
        XCTAssertNotNil(modelData, "Invalid file")

        let modelDataList = MovieList.fromJSON(modelData)
        XCTAssertNotNil(modelDataList, "Invalid JSON Data")
        
        let movies = modelDataList?.movies ?? []
        sut.movies = movies
        sut.currentPage = 1
        sut.totalPage = 100
        sut.isLoading = false
        
        let expectation = XCTestExpectation(description: "response")

        sut.loadNextPageIfPossible(movies[0]) {
            XCTAssertEqual(self.sut.movies.count, 8, "Should fetch 5 movies and append with previous 3 movies")
            XCTAssertEqual(self.sut.currentPage, 2, "Current page should be 2")
            XCTAssertEqual(self.sut.totalPage, 100, "Should not be change total Page. Should be 100")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
   
    
    
    func testPerformanceExample() throws {
        self.measure {
            
        }
    }

}

