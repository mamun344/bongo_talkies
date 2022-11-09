//
//  MovieListAPITests.swift
//  Bongo TalkiesTests
//
//  Created by Admin on 8/11/22.
//

import XCTest
@testable import Bongo_Talkies

final class MovieListAPITests: XCTestCase {
    
    var sut: APIManager!
    var urlSession: URLSession!
    

    override func setUpWithError() throws {
        try super.setUpWithError()
                
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        urlSession = URLSession(configuration: configuration)
        
        sut = APIManager(session: urlSession)
    }

    override func tearDownWithError() throws {
        sut = nil
        urlSession = nil

        try super.tearDownWithError()
    }
    
    
    
    
    func test_Movie_List_Request_With_Valid_Data() throws {
        let mockData: Data? = "movie_list_valid".fileJSONData()
        XCTAssertNotNil(mockData, "Invalid file")

        URLProtocolMock.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        sut.fetchTopMovies(page: 1) { result in
            switch result {
            case .success(let movieList):
                XCTAssertEqual(movieList.currentPage, 1, "Current page should be 1")
                XCTAssertEqual((movieList.movies ?? []).isEmpty, false, "Movie array should not be empty")

            case .failure(let error):
                XCTFail(error.description)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_Movie_List_Request_With_Invalid_Data() throws {
        let mockData: Data? = "movie_list_invalid".fileJSONData()
        XCTAssertNotNil(mockData, "Invalid file")

        URLProtocolMock.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        sut.fetchTopMovies(page: 1) { result in
            switch result {
            case .success(_):
                XCTFail("Should not get response")

            case .failure(let error):
                if case .jsonParseFailed = error {} else {
                    XCTFail("Should catch json parse error")
                }
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_Movie_List_Request_With_InValid_Response() throws {
        let mockData: Data? = "movie_list_valid".fileJSONData()
        XCTAssertNotNil(mockData, "Invalid file")

        
        let response = HTTPURLResponse(url: URL(string: APIUrl.movieDetailsURL(id: 0))!, statusCode: 401, httpVersion: "HTTP/1.1", headerFields: ["Content-Type": "application/json"])
        XCTAssertNotNil(response, "Invalid response")

        URLProtocolMock.requestHandler = { request in
            return (response!, mockData)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        sut.fetchTopMovies(page: 1) { result in
            switch result {
            case .success(_):
                XCTFail("Should not get response")

            case .failure(let error):
                if case .invalidHttp(_) = error {} else {
                    XCTFail("Should catch invalid https status error")
                }
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    func test_Movie_List_Request_With_InValid_HTTP_Data() throws {
        URLProtocolMock.requestHandler = { request in
            return (HTTPURLResponse(), nil)
        }
        
        let expectation = XCTestExpectation(description: "response")
        
        sut.fetchTopMovies(page: 1) { result in
            switch result {
            case .success(_):
                XCTFail("Should not get response")

            case .failure(let error):
                if case .noResponse = error {} else {
                    XCTFail("Should catch no response error")
                }
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }


    func testPerformanceExample() throws {
        self.measure {
            
        }
    }

}
