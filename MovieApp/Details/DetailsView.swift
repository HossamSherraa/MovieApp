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
        ScrollView {}
        .ignoresSafeArea()
        .padding(.bottom , -160)
        
    }
    
}

struct previewMEEE : PreviewProvider {
    static let dependencyContainer = HomeDependencyContainer()
    static var previews: some View {
        DetailsView(detailsViewFactory: dependencyContainer, movie: .init(poster_path: "/eQlEajrYVXjstXgvAjwRnQ3LU1s.jpg", id: 337404), moviePoster: Image("0"))
            
    }
}




//struct DetailsView_Preview : PreviewProvider {
//    static var previews: some View {
//        DetailsView()
//    }
//}
