//
//  MoviesCategory.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import SwiftUI
struct MoviesCategoryView : View {
    @EnvironmentObject var homeDependencyContainer : HomeDependencyContainer
    @StateObject var moviesCategoyViewModel : MoviesCategoryViewModel
    
    @State var isShowAll : Bool = false
    @State var isExpended = true
    var body: some View {
        VStack{
            HStack {
                Text(moviesCategoyViewModel.title)
                    .bold()
                    .font(.system(size: 20 , weight: .medium, design: .rounded))
                
                
                Spacer()
                
                NavigationLink(destination:
                                ShowAllView(categoryViewModel: moviesCategoyViewModel, isShowAll: $isShowAll), isActive: $isShowAll, label: {
                    Text("Show All")
                        .font(.system(size: 17 , weight: .bold, design: .rounded))
                        .offset(x: -20)
                })
                
                
                Button(action: {
                    withAnimation {
                        isExpended.toggle()
                    }
                    
                }
                       , label: {
                    Image(systemName: "chevron.up")
                        .accentColor(.black)
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .rotationEffect(isExpended ? Angle(degrees: 0) : Angle(degrees: 180))
                })
            }
            .padding()
            
            if isExpended{
            ScrollView(.horizontal , showsIndicators : false ){
                LazyHGrid(rows: [GridItem(.fixed(163))], pinnedViews: [], content: {
                    if !moviesCategoyViewModel.moviesViewModels.isEmpty{
                        ForEach(0..<8) { index in
                            NavigationLink(
                                destination: DetailsView.init(detailsViewFactory: self.homeDependencyContainer, movie: moviesCategoyViewModel.moviesViewModels[index].movie, moviePoster: moviesCategoyViewModel.moviesViewModels[index].poster ?? Image("0")),
                                label: {
                                    MovieCellView(viewModel: moviesCategoyViewModel.moviesViewModels[index])
                                    .frame(width: 117.0)
                                })
                           
                            
                            
                    }
                    }
                
            })
                .padding()
            }
            .transition(AnyTransition.offset(y: -10)
                            .combined(with: .opacity)
            )
           
            
                
            }
           
            
            
           
            
        }
        .frame(height: isExpended ? 240 : 40 )
        
        
    }
    
    
}

