//
//  ContentView.swift
//  MovieApp
//
//  Created by Hossam on 23/05/2021.
//

import SwiftUI

struct HomeView: View {
    
    let moviesCategoryFactory : MobiesCategoryFactory
    var body: some View {
        NavigationView{
            VStack{
                Text("THE MOVIES")
                    .font(.system(size: 22, weight: .heavy, design: .default))
                    .foregroundColor(.red)

            ScrollView(showsIndicators : false ){
               VStack {
                   
                MoviesCategoryView(moviesCategoyViewModel: moviesCategoryFactory.makeMoviesTopRatingCategoryViewModel())
                MoviesCategoryView(moviesCategoyViewModel: moviesCategoryFactory.makeMoviesPopularCategoryViewModel())
                MoviesCategoryView(moviesCategoyViewModel: moviesCategoryFactory.makeMoviesUpComingViewModel())
                MoviesCategoryView(moviesCategoyViewModel: moviesCategoryFactory.makeMoviesNowPlayingViewModel())
                }
            }
                
                
            }
            .navigationBarHidden(true)
        }
        }
}

protocol MobiesCategoryFactory {
    func makeMoviesPopularCategoryViewModel()->MoviesCategoryViewModel
    
    func makeMoviesTopRatingCategoryViewModel()->MoviesCategoryViewModel
    
    func makeMoviesUpComingViewModel()->MoviesCategoryViewModel
    
    func makeMoviesNowPlayingViewModel()->MoviesCategoryViewModel
}

