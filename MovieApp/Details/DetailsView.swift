//
//  DetailsView.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import SwiftUI
protocol DetailsViewFactory {
    func getMovieRecommendedViewModel(movieID : String) -> MoviesCategoryViewModel
    func getDetailtsViewModel(movie  : Movie , moviePoster : Image) -> DetailsViewModel
}
struct DetailsView : View {
    @StateObject var moviesCategoryViewModel : MoviesCategoryViewModel
    @StateObject var detailtViewModel : DetailsViewModel
    
    
    init(detailsViewFactory : DetailsViewFactory , movie : Movie , moviePoster : Image) {
        _detailtViewModel = StateObject(wrappedValue: detailsViewFactory.getDetailtsViewModel(movie: movie, moviePoster: moviePoster))
        _moviesCategoryViewModel = StateObject(wrappedValue: detailsViewFactory.getMovieRecommendedViewModel(movieID: movie.id.description))
        
    }
    var body: some View {
        ScrollView {
            VStack(spacing:0){
                ZStack{
                    Rectangle()
                        .overlay( detailtViewModel.backgroundImage?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                        )
                   
                        
                        .overlay(  Rectangle()
                                    .opacity(0.5) )
                        .ignoresSafeArea()
                    
                    
                    
                    
                    
                    VStack{
                        Text(detailtViewModel.title)
                            .font(Font.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            
                            .multilineTextAlignment(.center)
                        
                        Text(detailtViewModel.movieCategory)
                            .font(Font.system(size: 18, weight: .regular, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .offset( y: -20)
                    
                }
                
                .frame( height: 300)
                .clipped()
                ZStack{
                   
                    Rectangle()
                        .fill(Color(UIColor.systemGray6))
                        .frame( height: 120)
                        .offset(x: 0, y: -50)
                    HStack{
                        detailtViewModel.movieImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 115, height: 180)
                           
                            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                            .overlay(
                        RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                            .stroke(Color.white)
                            .frame(width: 115, height: 180)
                            
                        )
                        
                        VStack(alignment:.leading, spacing:25){
                            VStack(alignment:.leading , spacing:10){
                                Label(detailtViewModel.reviewsTitle, systemImage: "star")
                                    .foregroundColor(.white)
                                Label(detailtViewModel.time, systemImage: "clock")
                                    .foregroundColor(.white)
                                Label(detailtViewModel.releasedDate, systemImage: "calendar.badge.clock")
                                    .foregroundColor(.white)
                            }
                           
                            HStack{
                                LabelVertical(systemImage: "bookmark", title: "Watchlist")
                                LabelVertical(systemImage: detailtViewModel.isFavorite ? "heart.fill":"heart" , title: "Favourite")
                                    .onTapGesture {
                                        detailtViewModel.toggleFavorite()
                                    }
                                LabelVertical(systemImage: "square.and.arrow.up", title: "Share")
                                
                            }
                        }
                    
                        .offset(x:10 , y: -10)
                    }.offset(y: -110)
                
                }
             
                
                
                
                Group{
                    VStack(alignment:.leading , spacing:10){
                        Text("Overview")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        Text(detailtViewModel.overview)
                            .lineLimit(3)
                        Button(action: {}, label: {
                            Text("Read More")
                                .bold()
                                .offset( y: -10)
                        })
                        
                        
                        Text("Cast")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                        
                    }
                    .padding()
                    VStack(alignment:.leading){
                        if !detailtViewModel.movieCastViewModel.isEmpty {
                        ScrollView(.horizontal , showsIndicators : false ){
                            HStack(spacing:20){
                                ForEach(0..<detailtViewModel.movieCastViewModel.count) { index in
                                    ActorView(viewModel: detailtViewModel.movieCastViewModel[index])
                            }
                                
                            }
                        }
                        .padding(.leading , 20)
                        }
                        Text("Recommendation")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .padding(.horizontal)
                       
                            ScrollView(.horizontal , showsIndicators : false ){
                                LazyHGrid(rows: [GridItem(.fixed(163))], pinnedViews: [], content: {
                                    if !moviesCategoryViewModel.moviesViewModels.isEmpty{
                                        ForEach(0..<moviesCategoryViewModel.moviesViewModels.count) { index in
                                            MovieCellView(viewModel: moviesCategoryViewModel.moviesViewModels[index])
                                            .frame(width: 117.0)
                                               
                                    }
                                    }
                                
                            })
                                .padding()
                            }
                    }
                }
                .offset( y: -60)
               
                   
               
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .padding(.bottom , -160)
        
    }
    
}




//struct DetailsView_Preview : PreviewProvider {
//    static var previews: some View {
//        DetailsView()
//    }
//}
