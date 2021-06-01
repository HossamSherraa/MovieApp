//
//  MoviesDetailsRepository.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Combine
import Foundation
import SwiftUI
protocol MovieDetailsRepository {
    func fetchMovieDetails(movieID : String)->AnyPublisher<MovieDetails , Never>
    func fetchMovieCast(movieID : String)->AnyPublisher< [Actor], Error>
    func downloadBackgroundImageAt(path : String)->AnyPublisher<Image , Never>
    func addMovieToFavorite(_ movie : Movie)
    func removeMovieFromFavorite(_ movie : Movie)
    func isInFavorite(_ movie : Movie)->Bool
    func loadMovieVideo(movieID : String)->AnyPublisher<Video , Never>
    func openVideo(key : String)
    
}

struct MDBMovieDetailsRepository : MovieDetailsRepository {
    
    let mDBNetworkService : MDBNetworkService
    let imageDownloader : ImageDownloader
    let movieCache : MoviesCache
    let youtubeLoader : YouTubeLoader
    func fetchMovieDetails(movieID: String) -> AnyPublisher<MovieDetails, Never> {
        let url = mDBNetworkService.getMovieDetailsURL(movieID: movieID)
       return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieDetails.self, decoder: JSONDecoder())
        .replaceError(with: .init(backdrop_path: "", genres: [], vote_average: 0, vote_count: 0, status: "", release_date: "", overview: "", original_title: "", runtime: 0))
            .eraseToAnyPublisher()
    }
    
    func fetchMovieCast(movieID: String) -> AnyPublisher<[Actor], Error> {
        let url = mDBNetworkService.getMovieCastURL(movieID: movieID)

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Cast.self, decoder: JSONDecoder())
            .map(\.cast)
            .eraseToAnyPublisher()
    }
    
    func downloadBackgroundImageAt(path: String) -> AnyPublisher<Image, Never> {
        return imageDownloader
            .getImage(path: path, size: .medium)
            .eraseToAnyPublisher()
        
    }
    
    func addMovieToFavorite(_ movie: Movie) {
       let _ =  movieCache.saveMovieToFavorite(movie: movie)
            .sink(receiveCompletion: {_ in }) { (com) in }
           
    }
    
    func removeMovieFromFavorite( _ movie: Movie) {
        movieCache.removeFavortieMovie(movie: movie)
    }
    
    func isInFavorite(_ movie: Movie) -> Bool {
        movieCache.isExist(movie)
    }
    
    func loadMovieVideo(movieID : String) -> AnyPublisher<Video, Never> {
        let url = mDBNetworkService.getMovieVideo(movieID: movieID)
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: VideoResult.self, decoder: JSONDecoder())
            .replaceError(with: .init(results: []))
            .compactMap({$0.results.first { $0.site == "YouTube"}})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func openVideo(key : String){
        youtubeLoader.openYoutubeVideo(key: key)
    }
    
    
    
    
}

protocol YouTubeLoader {
    func openYoutubeVideo(key : String)
}

struct MDBYoutubeLoader : YouTubeLoader {
    func openYoutubeVideo(key: String) {
        if let youtubeURL = URL(string: "youtube://\(key)"),
               UIApplication.shared.canOpenURL(youtubeURL) {
               // redirect to app
               UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
           } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(key)") {
               // redirect through safari
               UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
           }
    }
    
    
}
