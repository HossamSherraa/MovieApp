//
//  File.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import SwiftUI
import Combine
protocol MovieCastRepository {
    func getImage(actor : Actor)->AnyPublisher<Image , Never>
}

struct MDBMovieCastRepository : MovieCastRepository{
    
    let service : MDBNetworkService
    func getImage(actor: Actor) -> AnyPublisher<Image, Never> {
        let url = service.getPosterImageURL(imagePath: actor.profile_path ?? "", size: .small)
        
        return  URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap({UIImage(data: $0)})
            .map({Image(uiImage:$0)})
            .replaceError(with: Image("0"))
            .eraseToAnyPublisher()
    }
}
