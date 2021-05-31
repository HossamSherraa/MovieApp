//
//  File.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Combine
import SwiftUI
protocol ImageDownloader {
    func getImage(path : String , size : ImageSize) -> AnyPublisher<Image, Never>
}

struct MDBimageDownloader : ImageDownloader {
    let mDBService : MDBNetworkService
   
    func getImage(path : String , size : ImageSize) -> AnyPublisher<Image, Never> {
        let imageUrl = mDBService.getPosterImageURL(imagePath:path, size: size)
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
