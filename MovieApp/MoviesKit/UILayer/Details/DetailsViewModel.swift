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
    internal init(movieID: String, movieImage: Image, movieDetailsRepository: MovieDetailsRepository ,movieCastRepository : MovieCastRepository ) {
        self.movieID = movieID
        self.movieImage = movieImage
        self.movieDetailsRepository = movieDetailsRepository
        self.movieCastRepository = movieCastRepository
        
        loadMovieDetails()
        loadCast()
    }
    
    var subscreptions : Set<AnyCancellable> = []
    let movieID : String
    let movieImage : Image
    let movieDetailsRepository : MovieDetailsRepository
    let movieCastRepository : MovieCastRepository
    
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
            .sink(receiveValue: { [weak self] movieDetails in
                self?.title = movieDetails.original_title
                self?.movieCategory = movieDetails.genres.description
                self?.reviewsTitle = movieDetails.vote_average.description + "(\(movieDetails.vote_count) Reviews)"
                self?.releasedDate = movieDetails.release_date + movieDetails.status
                self?.overview = movieDetails.overview
                
                self?.time = movieDetails.runtime.description
                
                self?.loadBackgroundImage(imagePath: movieDetails.backdrop_path)
                
            })
            .store(in: &subscreptions)
        
        
    }
    
    func loadBackgroundImage(imagePath : String){
        movieDetailsRepository
            .downloadBackgroundImageAt(path: imagePath)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (image) in
                self?.backgroundImage = image
            }
            .store(in: &subscreptions)
    }
    
    func loadCast(){
        movieDetailsRepository
            .fetchMovieCast(movieID: movieID)
            .flatMap(\.publisher)
            .map({MovieCastViewModel(actor: $0 , movieCastRepository: self.movieCastRepository)})
            .collect()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (com) in
             
            }, receiveValue: { [weak self] (value) in
                self?.movieCastViewModel = value
            })
            .store(in: &subscreptions)
    }
    
    
    
}






