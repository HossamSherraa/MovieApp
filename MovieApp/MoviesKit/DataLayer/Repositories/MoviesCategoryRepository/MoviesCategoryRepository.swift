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

class MDBMoviesCategoryRepository : MoviesCategoryRepository {
    internal init(mDBService: MDBNetworkService) {
        self.mDBService = mDBService
    }
    
    let mDBService : MDBNetworkService
    
    func fetchMovies(from url : URL ) -> AnyPublisher<[Movie], Error> {
        
       return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MoviesResult.self, decoder: JSONDecoder())
        .map(\.results)
        .print()
        .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
}



