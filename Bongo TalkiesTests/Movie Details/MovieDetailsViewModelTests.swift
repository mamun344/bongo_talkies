//
//  MovieDetailsViewModelTests.swift
//  Bongo TalkiesTests
//
//  Created by Admin on 8/11/22.
//

import XCTest
@testable import Bongo_Talkies

final class MovieDetailsViewModelTests: XCTestCase {
    
    var sut: MovieDetailsViewModel!
    var service: MovieAPIServiceMock!
    

    override func setUpWithError() throws {
        try super.setUpWithError()
        service = MovieAPIServiceMock(mockData: nil)
        
        let modelData: Data? = "movie_list_valid".fileJSONData()
        XCTAssertNotNil(modelData, "Invalid file")
        
        let modelDataList = MovieList.fromJSON(modelData)
        XCTAssertNotNil(modelDataList?.movies?.first, "Invalid JSON Data")
        
        sut = MovieDetailsViewModel(movie: modelDataList!.movies![0], apiService: service)
    }

    override func tearDownWithError() throws {
        sut = nil
        service = nil
        try super.tearDownWithError()
    }
    
    
    func test_MovieDetails_With_NoData_ErrorResponse() throws {
        service.mockData = nil
        service.error = .noResponse
        
        sut.isLoading = false
        
        let expectation = XCTestExpectation(description: "response")

        sut.refresh(internet: true) {
            XCTAssertEqual(self.sut.isLoading, false, "Loader should hide")
            XCTAssertEqual(self.sut.showAlert, true, "Should not get any movie")
            XCTAssertEqual(self.sut.alertMessage, ResponseError.noResponse.description, "Must show no response error")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
   
    func test_MovieList_With_Data_ErrorResponse() throws {
        service.mockData = nil
        service.error = .noResponse
        
        let modelData: Data? = "movie_details_valid".fileJSONData()
        XCTAssertNotNil(modelData, "Invalid file")
        
        let model = MovieDetails.fromJSON(modelData)
        XCTAssertNotNil(model, "Invalid JSON Data")
                
        sut.movieDetails = model!
        sut.isLoading = false
        
        let expectation = XCTestExpectation(description: "response")
        
        sut.refresh(internet: true) {
            XCTAssertEqual(self.sut.isLoading, false, "Loader should hide")
            XCTAssertEqual(self.sut.gotDetails, false, "Should not have details")
            XCTAssertEqual(self.sut.showAlert, true, "Should show error alert")
            XCTAssertEqual(self.sut.alertMessage, ResponseError.noResponse.description, "Should show proper error alert")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func test_MovieList_With_Service_Data_ErrorResponse() throws {
        let mockData: Data? = "movie_details_valid".fileJSONData()
        XCTAssertNotNil(mockData, "Invalid file")
                
        service.mockData = mockData
        service.error = .invalidUrl
                
        sut.isLoading = false
        
        let expectation = XCTestExpectation(description: "response")
        
        sut.refresh(internet: true) {
            XCTAssertEqual(self.sut.isLoading, false, "Loader should hide")
            XCTAssertEqual(self.sut.gotDetails, false, "Should not have details")
            XCTAssertEqual(self.sut.showAlert, true, "Should show error alert")
            XCTAssertEqual(self.sut.alertMessage, ResponseError.invalidUrl.description, "Should show proper error alert")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    func test_MovieList_With_Service_Data_NoError() throws {
        let mockData: Data? = "movie_details_valid".fileJSONData()
        XCTAssertNotNil(mockData, "Invalid file")
                
        service.mockData = mockData
        service.error = nil
                
        sut.isLoading = false
        
        let expectation = XCTestExpectation(description: "response")
        
        sut.refresh(internet: true) {
            XCTAssertEqual(self.sut.gotDetails, true, "Should have details")
            XCTAssertEqual(self.sut.isLoading, false, "Loader should hide")
            XCTAssertEqual((self.sut.movieDetails.overview ?? "").count > 0, true, "Should have details")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
    
    func testPerformanceExample() throws {
        self.measure {
            
        }
    }

}

