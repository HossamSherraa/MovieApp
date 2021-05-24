//
//  File.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import SwiftUI
struct ActorView : View {
    @StateObject var viewModel : MovieCastViewModel
    var body: some View {
        VStack{
            viewModel.profileImage?
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80, alignment: .center)
                .clipShape(Circle())
            
            Text(viewModel.name)
        }
    }
}
