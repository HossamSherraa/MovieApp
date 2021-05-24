//
//  MovieCellView.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import SwiftUI
struct MovieCellView : View {
    @EnvironmentObject var homeDependencyContainer : HomeDependencyContainer
    @StateObject var viewModel : MovieViewModel
    var body: some View {
       
        NavigationLink(
            destination: DetailsView(detailsViewFactory: homeDependencyContainer, movie: viewModel.movie, moviePoster: viewModel.poster ?? Image("0")),
            label: {
                viewModel.poster?
                    .resizable()
                    .clipped()
                    .clipShape( RoundedRectangle(cornerRadius: 10))
            })
              
                    

            
    }
    
    
}

