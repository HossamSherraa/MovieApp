//
//  HomeDependencyContainer.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Foundation
import SwiftUI
class HomeDependencyContainer  : MovieViewModelFactory , MobiesCategoryFactory , DetailsViewFactory , ObservableObject{
    func getMovieRecommendedViewModel(movieID : String) -> MoviesCategoryViewModel {
        return .init(moviesCategoryRepository: makeMoviesCategoryRepository(), movieViewModelFactory: self ,type: .recommended(movieID: movieID) , mDBService: makeMDBService(), title: "Coming Soon")
    }
    func makeMovieCastRepository()->MovieCastRepository {
        MDBMovieCastRepository(service: makeMDBService())
    }
    
    func getDetailtsViewModel(movie: Movie, moviePoster: Image) -> DetailsViewModel {
        return DetailsViewModel(movieID: movie.id.description, movieImage: moviePoster, movieDetailsRepository: makeMovieDetailsRepository(), movieCastRepository: makeMovieCastRepository())
    }
    
    func makeMovieDetailsRepository()->MovieDetailsRepository {
        return MDBMovieDetailsRepository(mDBNetworkService: makeMDBService(), imageDownloader: makeImageDownloader())
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
