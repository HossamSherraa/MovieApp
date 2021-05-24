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
        imageDownloader.getImage(path: movie.poster_path)
            .eraseToAnyPublisher()
    }
    
    
}


protocol  ImageDownloader {
    func getImage(  path : String)->AnyPublisher<Image , Never>
}

struct MDBimageDownloader : ImageDownloader {
    let mDBService : MDBNetworkService
   
    func getImage(path : String) -> AnyPublisher<Image, Never> {
        let imageUrl = mDBService.getPosterImageURL(imagePath:path, size: .small)
      return  URLSession.shared.dataTaskPublisher(for: imageUrl)
            .map(\.data)
            .retry(2)
        .compactMap({
            if let image = UIImage(data: $0) {
                return Image(uiImage:image)}
            
            return nil
        })
        .replaceError(with: Image("0"))
            .eraseToAnyPublisher()
            
    }
    
    
}
