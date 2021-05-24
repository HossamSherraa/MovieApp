//
//  File.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Combine
import SwiftUI
class MovieCastViewModel : ObservableObject {
    
    internal init(actor: Actor, movieCastRepository: MovieCastRepository) {
        self.actor = actor
        self.movieCastRepository = movieCastRepository
        loadActorImage()
    }
    
    
    
    @Published var profileImage : Image?
    @Published var name : String = ""
    
    var subscribtions : Set<AnyCancellable> = []
    let actor : Actor
    let movieCastRepository : MovieCastRepository
    
    func loadActorImage(){
        
        movieCastRepository
            .getImage(actor: actor)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (image) in
                self?.profileImage = image
            }
            .store(in: &subscribtions)
    }
    
}
