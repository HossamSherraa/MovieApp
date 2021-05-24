//
//  MoviesCategoryRepository.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Combine
import Foundation
protocol MoviesCategoryRepository{
    func fetchMovies(from url : URL)->AnyPublisher<[Movie] , Error>
}

struct MDBMoviesCategoryRepository : MoviesCategoryRepository {
    let mDBService : MDBNetworkService
    
    func fetchMovies(from url : URL) -> AnyPublisher<[Movie], Error> {
        
       return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MoviesResult.self, decoder: JSONDecoder())
        .map(\.results)
        .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
  
    
}
