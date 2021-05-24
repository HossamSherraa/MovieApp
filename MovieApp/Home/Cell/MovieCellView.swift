//
//  MovieCellView.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import SwiftUI
struct MovieCellView : View {
    @StateObject var viewModel : MovieViewModel
    var body: some View {
       
        
                viewModel.poster?
                    .resizable()
                    .clipped()
                    .clipShape( RoundedRectangle(cornerRadius: 10))
                    

            
    }
    
    
}

