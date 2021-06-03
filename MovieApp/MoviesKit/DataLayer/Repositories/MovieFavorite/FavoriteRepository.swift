//
//  FavoriteRepository.swift
//  MovieApp
//
//  Created by Hossam on 29/05/2021.
//


import Combine
import Foundation
enum MovieFavoriteError : Error {
    case faildToSaveMovie
}
protocol FavoriteRepository {
    func getFavoriteMovies()->AnyPublisher<[Movie], Never>
    func saveMovieToFavorite(movie : Movie)->AnyPublisher<Bool , Error>
}

protocol MoviesCache {
    func getFavoriteMovies()->AnyPublisher<[Movie], Never>
    func saveMovieToFavorite(movie : Movie)->AnyPublisher<Bool , Error>
    func removeFavortieMovie(movie : Movie)
    func isExist(_ movie : Movie)->Bool
}

protocol MoviesCoder {
    func encodeMovie(_ movie : Movie)->AnyPublisher<[String:Any] , Error>
    func decodeMovie(movieData : [String:Any] )->AnyPublisher<[Movie] , Error>
}

struct MovieFavortieRepository  {
    
    let moviesCache : MoviesCache
 
    func getFavoriteMovies() -> AnyPublisher<[Movie], Never> {
        moviesCache.getFavoriteMovies()
    }
    
    func saveMovieToFavorite(movie: Movie) -> AnyPublisher<Bool, Error> {
        moviesCache.saveMovieToFavorite(movie: movie)
    }
   
}




/*
 [
 "MovieID":
 [Name:MovieName , [Poster : Data] , [ratings : [7.5] , "MovieID" : "dsfdsf"]]
 ]
 */


struct FavoriteMoviesCoder : MoviesCoder {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    func encodeMovie(_ movie: Movie) -> AnyPublisher<[String : Any], Error> {
        Just(movie)
            .tryMap({try? encoder.encode($0)})
            .tryMap({ try? JSONSerialization.jsonObject(with: $0!, options: []) as? [String:Any] })
            .compactMap({$0})
            .eraseToAnyPublisher()
         
      

    }
    
    func decodeMovie(movieData: [String : Any]) -> AnyPublisher<[Movie], Error> {
        Just(movieData)
            .tryMap({try JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted)})
            .decode(type: [String:Movie].self, decoder: JSONDecoder())
            .flatMap({$0.values.publisher})
            .collect()
            .eraseToAnyPublisher()
    }
    
    
}

class MoviesCacheUserDefaults : MoviesCache  {
    var savedData : [String : Any] = [:]
    var wrapperName : String { "favoriteMovies"}
    let userDafaults = UserDefaults.standard
    let moviesCoder : MoviesCoder
    
    init(moviesCoder : MoviesCoder) {
        self.moviesCoder = moviesCoder
        loadSavedData()
    }
    func getFavoriteMovies() -> AnyPublisher<[Movie], Never> {
        Just(savedData)
            .flatMap({self.moviesCoder.decodeMovie(movieData: $0)})
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
    
    func saveMovieToFavorite(movie: Movie) -> AnyPublisher<Bool, Error> {
       Just(movie)
        .flatMap({self.moviesCoder.encodeMovie($0)})
        .tryMap { codedMovie -> Bool in
            self.updateSavedData(newDic: codedMovie, movieID: movie.id.description)
            return true
        }
        .eraseToAnyPublisher()
    
    }
    
     func updateSavedData(newDic : [String : Any] , movieID : String){
        savedData.updateValue(newDic, forKey: movieID)
        userDafaults.setValue(savedData, forKey: wrapperName)
        loadSavedData()
    }
     func loadSavedData(){
        savedData =  userDafaults.dictionary(forKey: wrapperName) ?? [:]
    }
    
    func removeFavortieMovie(movie : Movie){
        savedData[movie.id.description] = nil
        userDafaults.setValue(savedData, forKey: wrapperName)
        loadSavedData()
    }
    
    func isExist(_ movie : Movie)->Bool {
        savedData.keys.contains(movie.id.description)
    }
    
    func removeAll(){
        savedData.removeAll()
        userDafaults.setValue(savedData, forKey: wrapperName)
        loadSavedData()
    }
    
    func isEmpty()->Bool{
        savedData.isEmpty
    }
}


class MoviesCacheUserDefaults_ForTesting : MoviesCacheUserDefaults {
    override var wrapperName: String {"favoriteMovies_Testing"}
}
