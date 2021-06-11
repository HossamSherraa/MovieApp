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
        ZStack(alignment:.bottom) {
            NavigationView{
                VStack(alignment:.center){
                    
                    HStack{

                        NavigationLink(
                            destination: FavoriteMovies(favoritesMoviesViewModel: moviesCategoryFactory.makeFavoritesMoviesViewModel()),
                            label: {
                                    Image(systemName: "heart.text.square")
                                        .font(.system(size: 22, weight: .heavy, design: .default))
                                        .foregroundColor(.red)
                            })
                        
                        .frame(minWidth: 100, idealWidth: .infinity, maxWidth: .infinity, alignment: .trailing)
                        .overlay(
                            Text("THE MOVIES")
                                    .font(.system(size: 22, weight: .heavy, design: .default))
                                    .foregroundColor(.red)
                        )
                    }
                    .padding(.horizontal)
                    
                    
                   
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
            if #available(iOS 15.0, *) {
                Text("Blue Me ")
                    .frame(minWidth: 200, idealWidth: .infinity, maxWidth: .infinity , minHeight: 40)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
struct previewHere : PreviewProvider {
    static let dependencyContainer = HomeDependencyContainer()
    static var previews: some View {
        HomeView(moviesCategoryFactory: dependencyContainer)
            .environmentObject(dependencyContainer)
            
    }
}

protocol MobiesCategoryFactory {
    func makeMoviesPopularCategoryViewModel()->MoviesCategoryViewModel
    
    func makeMoviesTopRatingCategoryViewModel()->MoviesCategoryViewModel
    
    func makeMoviesUpComingViewModel()->MoviesCategoryViewModel
    
    func makeMoviesNowPlayingViewModel()->MoviesCategoryViewModel
    
    func makeFavoritesMoviesViewModel()->FavoritesMoviesViewModel
}

