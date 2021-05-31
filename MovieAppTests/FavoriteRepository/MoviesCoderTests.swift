//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Hossam on 30/05/2021.
//

import XCTest
import Combine
@testable import MovieApp

class MoviesCoderTests: XCTestCase {

    var subscriptions : Set<AnyCancellable> = []
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFavoriteMoviesCoder() throws {
        let exceptation = expectation(description: "TestFavoriteMoviesCoder")
      let favoriteMoviesCoder =   FavoriteMoviesCoder()
        favoriteMoviesCoder.encodeMovie(.init(poster_path: "SomePath", id: 44))
            .sink { _ in
            } receiveValue: { (dic) in
                exceptation.fulfill()
                let idValue = (dic["id"] as? Int) ?? 0
                let posterPathValue = (dic["poster_path"] as? String) ?? ""
                XCTAssertEqual(idValue, 44)
                XCTAssertEqual(posterPathValue, "SomePath")
            }
            .store(in: &subscriptions)
        self.wait(for: [exceptation], timeout: 0.2)

    }
    

    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

