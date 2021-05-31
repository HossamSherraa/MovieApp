//
//  FavoriteMovies.swift
//  MovieApp
//
//  Created by Hossam on 31/05/2021.
//

import SwiftUI

struct FavoriteMovies: View {
    @StateObject var favoritesMoviesViewModel : FavoritesMoviesViewModel
    var body: some View {
        VStack{
            
            ScrollView{
                LazyVStack(spacing:20){
                    ForEach.init(favoritesMoviesViewModel.favoritesMovies, id: \.movie.id) { element in
                        FavoriteMovieRow(favoriteMovieRowViewModel: element)
                    }
                       
            }
                    
                }
                
            }
            .navigationTitle("Favorite Movies")
        }
    }





struct FavoriteMovieRow : View {
    @StateObject var favoriteMovieRowViewModel : FavoriteMovieRowViewModel
    var body: some View {
        RoundedRectangle(cornerRadius: 20 , style: .continuous)
            .fill( Color.white)
            .frame( height: 70, alignment: .center)
            .padding(.horizontal)
            .shadow(color: Color(#colorLiteral(red: 0.06658691913, green: 0.06861826032, blue: 0.01044648606, alpha: 0.08419721554)), radius: 15, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: 0.0)
            .overlay(HStack(spacing:20){
                favoriteMovieRowViewModel.movieImage?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(width: 45, height:45, alignment: .center)
                
                Text(favoriteMovieRowViewModel.movieName)
                    .bold()
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundColor(Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)))
                    .onTapGesture {
                        favoriteMovieRowViewModel.onPressremoveFromFavorite()
                    }
            }
            .padding()
            .padding(.horizontal))
    }
    
}
