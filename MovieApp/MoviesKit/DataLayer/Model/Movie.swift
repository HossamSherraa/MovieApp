//
//  Movie.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Foundation
struct MoviesResult : Codable {
    let results : [Movie]
}
struct Movie : Codable {
    let poster_path : String
    let id : Int
}
