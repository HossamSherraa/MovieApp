//
//  File.swift
//  MovieApp
//
//  Created by Hossam on 31/05/2021.
//

import Combine
import Foundation
import SwiftUI
class FavoritesMoviesViewModel : ObservableObject {
    internal init(favoriteMoviesRepository: FavoritesMoviesRepository) {
        self.favoriteMoviesRepository = favoriteMoviesRepository
        loadFavoriteMovies()
        linkNotifiers()
    }
    var movieDidRemovedFromFavorite : PassthroughSubject<Movie , Never> = PassthroughSubject()
    private var subscriptions : Set<AnyCancellable> = []
    @Published var favoritesMovies : [FavoriteMovieRowViewModel] = []
    private let favoriteMoviesRepository : FavoritesMoviesRepository
    
    func loadViewModelData(){
        loadFavoriteMovies()
    }
    func loadFavoriteMovies(){
        favoriteMoviesRepository
            .getFavoritesMoviesViewModel(didRemoveNotifier: movieDidRemovedFromFavorite)
            .assign(to: \.favoritesMovies, on: self)
            .store(in: &subscriptions)
    }
    
    func linkNotifiers(){
        movieDidRemovedFromFavorite
            .sink { [weak self]movie in
                self?.loadFavoriteMovies()
            }.store(in: &subscriptions)
    }
}

protocol FavoritesMoviesRepository {
    func getFavoritesMoviesViewModel(didRemoveNotifier : PassthroughSubject<Movie , Never>)->AnyPublisher<[FavoriteMovieRowViewModel] , Never>
}

struct MDBFavoriteMoviesRepository : FavoritesMoviesRepository{
    let favoritesMoviesRepositoryFactory : FavoritesMoviesRepositoryFactory
    func getFavoritesMoviesViewModel(didRemoveNotifier: PassthroughSubject<Movie, Never>) -> AnyPublisher<[FavoriteMovieRowViewModel], Never> {
            moviesCache.getFavoriteMovies()
            .flatMap(\.publisher)
            .map({favoritesMoviesRepositoryFactory.getViewModel(movie: $0 , didRemoveNotifier: didRemoveNotifier)})
            .collect()
            .eraseToAnyPublisher()
    }
    
    
    let moviesCache : MoviesCache
    
}

protocol FavoritesMoviesRepositoryFactory{
    func getViewModel( movie : Movie, didRemoveNotifier : PassthroughSubject<Movie , Never>)->FavoriteMovieRowViewModel
}
class FavoriteMovieRowViewModel : ObservableObject {
    internal init(movie: Movie, movieDetailsRepository: MovieDetailsRepository , didRemoveNotifier : PassthroughSubject<Movie , Never>  ) {
        self.movie = movie
        self.movieDetailsRepository = movieDetailsRepository
        self.didRemoveNotifier = didRemoveNotifier
        
        loadMovieRowViewModel()
    }
    
   
    
    let movie : Movie
    let movieDetailsRepository : MovieDetailsRepository
    let didRemoveNotifier : PassthroughSubject<Movie , Never>
    var subscriptions : Set<AnyCancellable> = []
    @Published var movieImage : Image?
    @Published var movieName : String = ""
    
    
    func loadMovieRowViewModel (){
        movieDetailsRepository.fetchMovieDetails(movieID: movie.id.description)
            .map({ [weak self] movieDetails -> String in
                DispatchQueue.main.async {
                    self?.movieName = movieDetails.original_title
                }
                return movieDetails.backdrop_path
            })
            .flatMap(movieDetailsRepository.downloadBackgroundImageAt(path:))
            .receive(on: DispatchQueue.main)
            .sink {[weak self] image in
                self?.movieImage = image
            }
            .store(in: &subscriptions)
        
    }
    
    
    @objc
    func onPressremoveFromFavorite(){
        movieDetailsRepository.removeMovieFromFavorite(movie)
        didRemoveNotifier.send(movie)
    }
    
    
    
    
    
}


