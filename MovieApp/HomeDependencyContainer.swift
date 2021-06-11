//
//  HomeDependencyContainer.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Foundation
import SwiftUI
import Combine
class HomeDependencyContainer  : MovieViewModelFactory , MobiesCategoryFactory , DetailsViewFactory , ObservableObject, FavoritesMoviesRepositoryFactory{
    //ommint Herer Xhabge
    lazy var favoriteMoviesCache : MoviesCache = {
        func makeMoviesCoder()->MoviesCoder{
            FavoriteMoviesCoder()
        }
        func makeMoviesCache()->MoviesCache {
            MoviesCacheUserDefaults(moviesCoder: makeMoviesCoder())
        }
        return makeMoviesCache()
    }()
    
    
    
    func getViewModel(movie: Movie, didRemoveNotifier: PassthroughSubject<Movie, Never>) -> FavoriteMovieRowViewModel {
        FavoriteMovieRowViewModel(movie: movie, movieDetailsRepository: makeMovieDetailsRepository(), didRemoveNotifier: didRemoveNotifier)
    }
    
    func makeFavoritesMoviesRepository()->FavoritesMoviesRepository {
        return MDBFavoriteMoviesRepository(favoritesMoviesRepositoryFactory: self, moviesCache: favoriteMoviesCache)
    }
    func makeFavoritesMoviesViewModel() -> FavoritesMoviesViewModel {
        FavoritesMoviesViewModel(favoriteMoviesRepository: makeFavoritesMoviesRepository())
    }
    
    func getMovieRecommendedViewModel(movieID : String) -> MoviesCategoryViewModel {
        return .init(moviesCategoryRepository: makeMoviesCategoryRepository(), movieViewModelFactory: self ,type: .recommended(movieID: movieID) , mDBService: makeMDBService(), title: "Coming Soon")
    }
    func makeMovieCastRepository()->MovieCastRepository {
        MDBMovieCastRepository(service: makeMDBService())
    }
    
    func getDetailtsViewModel(movie: Movie, moviePoster: Image) -> DetailsViewModel {
        return DetailsViewModel(movieID: movie.id.description, movieImage: moviePoster, movieDetailsRepository: makeMovieDetailsRepository(), movieCastRepository: makeMovieCastRepository())
    }
    
    func makeYoutubeLoader()->YouTubeLoader{
        MDBYoutubeLoader()
    }
    
    func makeMovieDetailsRepository()->MovieDetailsRepository {
        return MDBMovieDetailsRepository(mDBNetworkService: makeMDBService(), imageDownloader: makeImageDownloader(), movieCache: favoriteMoviesCache, youtubeLoader: makeYoutubeLoader())
    }
    
    func makeImageDownloader()->ImageDownloader {
        MDBimageDownloader(mDBService: makeMDBService())
    }
    func makePosterRepository()->PosterRepository {
        MDBPosterRepository(imageDownloader: makeImageDownloader())
    }
    func makeMovieModel(movie: Movie) -> MovieViewModel {
        MovieViewModel(movie: movie, posterRepository: makePosterRepository())
    }
    
    func makeMDBService()->MDBNetworkService {
        .shared
    }
    func makeMoviesCategoryRepository()->MoviesCategoryRepository {
        MDBMoviesCategoryRepository(mDBService: makeMDBService())
    }
    
   
    
    
    
    func makeMoviesPopularCategoryViewModel()->MoviesCategoryViewModel {
        
        return .init(moviesCategoryRepository: makeMoviesCategoryRepository(), movieViewModelFactory: self ,type: .popular , mDBService: makeMDBService(), title: "Popular Movies")
    }
    
    func makeMoviesTopRatingCategoryViewModel()->MoviesCategoryViewModel {
        
        return .init(moviesCategoryRepository: makeMoviesCategoryRepository(), movieViewModelFactory: self ,type: .topRated , mDBService: makeMDBService(), title: "Top Rated Movies")
    }
    
    func makeMoviesUpComingViewModel()->MoviesCategoryViewModel {
        
        return .init(moviesCategoryRepository: makeMoviesCategoryRepository(), movieViewModelFactory: self ,type: .upComing , mDBService: makeMDBService(), title: "Coming Soon")
    }
    
    func makeMoviesNowPlayingViewModel()->MoviesCategoryViewModel {
        
        return .init(moviesCategoryRepository: makeMoviesCategoryRepository(), movieViewModelFactory: self ,type: .nowPlaying , mDBService: makeMDBService(), title: "Now Playing")
    }
    
}
