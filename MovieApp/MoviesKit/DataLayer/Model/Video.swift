//
//  File.swift
//  MovieApp
//
//  Created by Hossam on 31/05/2021.
//

import Foundation

struct VideoResult : Codable {
    let results : [Video]
}
struct Video : Codable {
    let key : String
    let site : String
}
