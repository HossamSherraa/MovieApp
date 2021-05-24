//
//  MDBService.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import Foundation
enum ImageSize : String {
     case small = "200"
     case medium = "500"
}

class MDBNetworkService {
    static let shared = MDBNetworkService.init()
    let apiKey = "b300a17abfe9576e130d3c6510d3d3ad"
    let baseURL =  "https://api.themoviedb.org/"
    func getPopularMoviesURL()->URL {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = "/3/movie/popular"
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        guard let url = urlComponents?.url else {fatalError("Cannot Create URL")}
        return url
    }
    
    func getPosterImageURL(imagePath : String , size : ImageSize)->URL{
        
        let urlComponents = URLComponents(string: "https://image.tmdb.org/t/p/w\(size.rawValue + imagePath)")
        
        return urlComponents!.url!
    }
    
    func getNowPlayingMoviesURL()->URL {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = "/3/movie/now_playing"
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        guard let url = urlComponents?.url else {fatalError("Cannot Create URL")}
        return url
    }
    
    func getTopRatedMoviesURL()->URL {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = "/3/movie/top_rated"
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        guard let url = urlComponents?.url else {fatalError("Cannot Create URL")}
        return url
    }
    
    func getUpcomingMoviesURL()->URL {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = "/3/movie/upcoming"
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        guard let url = urlComponents?.url else {fatalError("Cannot Create URL")}
        return url
    }
    
    func getRecommendationURL(movieID : String)->URL {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = "/3/movie/\(movieID)/recommendations"
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        guard let url = urlComponents?.url else {fatalError("Cannot Create URL")}
        
        return url
        
    }
    
    func getMovieCastURL(movieID : String)->URL {
//        https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key=<<api_key>>&language=en-US
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = "/3/movie/\(movieID)/credits"
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        guard let url = urlComponents?.url else {fatalError("Cannot Create URL")}
        return url
        
    }
    
    
    func getMovieDetailsURL(movieID : String)->URL {
//        https://api.themoviedb.org/3/movie/{movie_id}?api_key=<<api_key>>&language=en-US
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.path = "/3/movie/\(movieID)"
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        guard let url = urlComponents?.url else {fatalError("Cannot Create URL")}
        return url

    }
    
    
    
}
