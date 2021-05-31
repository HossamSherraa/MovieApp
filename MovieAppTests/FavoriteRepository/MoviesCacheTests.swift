//
//  MoviesCacheTests.swift
//  MovieAppTests
//
//  Created by Hossam on 30/05/2021.
//

import XCTest
import Combine
@testable import MovieApp

class MoviesCacheTests: XCTestCase {

    var subscriptions : Set<AnyCancellable> = []
    lazy var exceptation = expectation(description: "TestMoviesCache")
    let moviesCoder = FavoriteMoviesCoder()
    lazy var moviesCacheUserDefaults = MoviesCacheUserDefaults_ForTesting(moviesCoder: moviesCoder)
    let movie = Movie(poster_path: "randoPath", id: Int.random(in: 1...1000))
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFavoriteMovies_Add() throws {
        moviesCacheUserDefaults
            .saveMovieToFavorite(movie: movie)
            .sink(receiveCompletion: {_ in }) { isCompleted in
                self.moviesCacheUserDefaults.getFavoriteMovies()
                    .sink { movies in
                        let userDefaultDataCount = UserDefaults.standard.dictionary(forKey: self.moviesCacheUserDefaults.wrapperName)?.count ?? 0
                        XCTAssertEqual(userDefaultDataCount, movies.count)
                        XCTAssert(movies.contains(self.movie))
                    }
                    .store(in: &self.subscriptions)
                self.exceptation.fulfill()
            }
            .store(in: &subscriptions)
        
        wait(for: [exceptation], timeout: 0.1)
            
        

    }
    
    
    func testFavoriteMovies_Remove() throws {
        try testFavoriteMovies_Add()
        XCTAssert(moviesCacheUserDefaults.isExist(movie))
        moviesCacheUserDefaults.removeFavortieMovie(movie: movie)
        XCTAssertFalse(moviesCacheUserDefaults.isExist(movie))
        
        
    }
    

    
    func testFavoriteMovies_Clean() throws {
        moviesCacheUserDefaults.removeAll()
        XCTAssert(moviesCacheUserDefaults.isEmpty())
    }

}
