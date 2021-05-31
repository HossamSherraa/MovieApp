//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Foundation
struct MovieDetails : Codable{
    var backdrop_path : String
    var genres : [Genre]
    var vote_average : Double
    var vote_count : Int
    var status : String
    var release_date : String
    var overview : String
    var original_title : String
    var runtime : Int
}



