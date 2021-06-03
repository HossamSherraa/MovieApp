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
    @Published var isFavorite : Bool = false
    @Published var overview : String = ""
    @Published var isVideoAvailable : Bool = false

    @Published var movieCastViewModel : [MovieCastViewModel] = []
    
    var videoKey : String?
    
    func loadMovieDetails(){
      loadMovieDetailsState()
      loadMovieDetailsData()
      loadCast()
      loadVideoStatus()
        
        
    }
    
    func loadMovieDetailsData(){
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
        
        
        movieDetailsRepository
            .loadMovieVideo(movieID: movieID)
            .sink { (video) in
                
            }
            .store(in: &subscreptions)
        
        
    }
    func loadMovieDetailsState(){
       isFavorite =  movieDetailsRepository.isInFavorite(.init(poster_path: nil, id: Int(movieID)!))
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
    
    func loadVideoStatus(){
        movieDetailsRepository
            .loadMovieVideo(movieID: movieID)
            
            .sink { [weak self] video in
                self?.videoKey = video.key
                self?.isVideoAvailable = true
            }.store(in: &subscreptions)
    }
    
    
    func toggleFavorite(){
        isFavorite ? movieDetailsRepository.removeMovieFromFavorite(.init(poster_path: nil, id: Int(movieID)!)): movieDetailsRepository.addMovieToFavorite(.init(poster_path: nil, id: Int(movieID)!))
        isFavorite.toggle()
    }
    
    
    func onPressPlay(){
        if let videoKey = videoKey {
        movieDetailsRepository
            .openVideo(key: videoKey )
            
        }
    }
    
}






