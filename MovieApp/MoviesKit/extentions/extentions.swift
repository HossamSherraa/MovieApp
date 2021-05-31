//
//  extentions.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Foundation

extension Array where Element == Genre {
    var description : String {
        var result = ""
        self.forEach { (genre) in
            result += "," + genre.name
        }
        result.removeFirst()
        return result
    }
}
