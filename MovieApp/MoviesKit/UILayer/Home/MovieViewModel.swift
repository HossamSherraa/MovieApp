//
//  CellViewModel.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Foundation
import Combine
import SwiftUI
class MovieViewModel : ObservableObject {
    internal init(movie: Movie, posterRepository: PosterRepository) {
        self.movie = movie
        self.posterRepository = posterRepository
        loadPosterImage()
    }
    
    @Published var poster : Image? = nil
    let movie : Movie
    let posterRepository : PosterRepository
    
    var subscriptions : Set<AnyCancellable> = []
    
    func loadPosterImage(){
        posterRepository
            .getPosterImage(movie: movie)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                self?.poster = image
            }
            .store(in: &subscriptions)
    }
    
}
