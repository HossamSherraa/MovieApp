//
//  ShowAllView.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import SwiftUI
struct ShowAllView : View {
    let categoryViewModel : MoviesCategoryViewModel
    @Binding var isShowAll : Bool
    var body: some View {
        VStack(alignment:.leading){
            HStack{
                Button(action: {
                    isShowAll.toggle()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 22, weight: .heavy, design: .default))
                        .foregroundColor(.black)
                        .offset(x: 20)
                }
                
                Spacer()
                Text("Popular")
                    .font(.system(size: 22, weight: .heavy, design: .default))
                    .foregroundColor(.red)
                Spacer()
            }
                
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: [.init(.adaptive(minimum: 140, maximum: 190))]) {
                    ForEach(0..<categoryViewModel.moviesViewModels.count) { index in
                        MovieCellView(viewModel: categoryViewModel.moviesViewModels[index])
                            
                    }
                }
                
            }
            .navigationBarHidden(true)
        }
        
    }
}
