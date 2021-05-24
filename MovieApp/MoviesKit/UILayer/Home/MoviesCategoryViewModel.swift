//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Combine
import Foundation



enum CategoryType {
    case topRated
    case upComing
    case nowPlaying
    case popular
    case recommended(movieID : String)
}
class MoviesCategoryViewModel : ObservableObject {
    private var subscriptions : Set<AnyCancellable> = []
    private let movieViewModelFactory : MovieViewModelFactory
    @Published var moviesViewModels : [MovieViewModel] = []
    let moviesCategoryRepository : MoviesCategoryRepository
    let mDBService : MDBNetworkService
    let type : CategoryType
    let title : String
   
    
    
    internal init(moviesCategoryRepository: MoviesCategoryRepository , movieViewModelFactory : MovieViewModelFactory , type : CategoryType,
                  mDBService : MDBNetworkService , title : String) {
        self.moviesCategoryRepository = moviesCategoryRepository
        self.movieViewModelFactory = movieViewModelFactory
        self.type = type
        self.mDBService = mDBService
        self.title = title
        loadMovies()
    }
    
    func loadMovies(){
        
        moviesCategoryRepository
            .fetchMovies(from: getServiceURL())
            .flatMap({$0.publisher})
            .map({self.movieViewModelFactory.makeMovieModel(movie: $0)})
            .collect()
            .sink(receiveCompletion: {completion in
                print("Did Finished Loading Category Movies" , self.type)
            }) { cellViewModels in
                self.moviesViewModels = cellViewModels
            }
            .store(in: &subscriptions)
    }
    
    func getServiceURL()->URL{
        switch  type {
        case .upComing: return  mDBService.getUpcomingMoviesURL()
        case .popular: return mDBService.getPopularMoviesURL()
        case .nowPlaying: return mDBService.getNowPlayingMoviesURL()
        case .topRated: return mDBService.getTopRatedMoviesURL()
        case .recommended(let movieID) : return mDBService.getRecommendationURL(movieID: movieID)
        }
    }
    
}

protocol MovieViewModelFactory{
    func makeMovieModel(movie : Movie)->MovieViewModel
}


