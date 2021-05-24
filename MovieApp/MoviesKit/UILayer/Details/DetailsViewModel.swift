//
//  DetailsViewModel.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Foundation
import Combine
import SwiftUI

class DetailsViewModel : ObservableObject {
    internal init(movieID: String, movieImage: Image, movieDetailsRepository: MovieDetailsRepository) {
        self.movieID = movieID
        self.movieImage = movieImage
        self.movieDetailsRepository = movieDetailsRepository
        
        loadMovieDetails()
    }

    var subscreptions : Set<AnyCancellable> = []
    let movieID : String
    let movieImage : Image
    let movieDetailsRepository : MovieDetailsRepository
    
    //State
    @Published var backgroundImage : Image?
    @Published var title : String = ""
    @Published var movieCategory = ""
    @Published var reviewsTitle = ""
    @Published var time : String = ""
    @Published var releasedDate : String = ""
    
    @Published var overview : String = ""
    
    @Published var movieCastViewModel : [MovieCastViewModel] = []
    
    func loadMovieDetails(){
        movieDetailsRepository
            .fetchMovieDetails(movieID: movieID)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { movieDetails in
                self.title = movieDetails.original_title
                self.movieCategory = movieDetails.genres.description
                self.reviewsTitle = movieDetails.vote_average.description + "(\(movieDetails.vote_count) Reviews)"
                self.releasedDate = movieDetails.release_date + movieDetails.status
                self.overview = movieDetails.overview
                
                self.time = movieDetails.runtime.description
            
                self.loadBackgroundImage(imagePath: movieDetails.backdrop_path)
            })
            .store(in: &subscreptions)
        
        
    }
    
    func loadBackgroundImage(imagePath : String){
        movieDetailsRepository
            .downloadBackgroundImageAt(path: imagePath)
            .receive(on: DispatchQueue.main)
            .sink { (image) in
                self.backgroundImage = image
            }
            .store(in: &subscreptions)
    }
   
    
}


class MovieCastViewModel : ObservableObject {
    @Published var profile : Image?
    @Published var name : String = ""
}

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
