//
//  ShowAllView.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import SwiftUI
struct ShowAllView : View {
    let categoryViewModel : MoviesCategoryViewModel

    var body: some View {
        
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [.init(.adaptive(minimum: 140, maximum: 190))]) {
                    ForEach(0..<categoryViewModel.moviesViewModels.count) { index in
                        MovieCellView(viewModel: categoryViewModel.moviesViewModels[index])
                            
                    }
                }
                
            }
            .navigationTitle(categoryViewModel.title)
        
        
    }
}
