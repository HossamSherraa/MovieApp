//
//  PosterRepository.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Combine
import SwiftUI
import Foundation
protocol PosterRepository {
    func getPosterImage(movie : Movie)->AnyPublisher<Image , Never>
}

struct MDBPosterRepository : PosterRepository {
    let imageDownloader : ImageDownloader
    func getPosterImage(movie : Movie) -> AnyPublisher<Image, Never> {
        imageDownloader.getImage(path: movie.poster_path ?? "", size: .small)
            .eraseToAnyPublisher()
    }
    
    
}


