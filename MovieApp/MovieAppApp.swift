//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Hossam on 23/05/2021.
//

import SwiftUI

@main
struct MovieAppApp: App {

    var body: some Scene {
        WindowGroup {
            let dependencyContainer = HomeDependencyContainer()
            HomeView(moviesCategoryFactory: dependencyContainer)
                .environmentObject(dependencyContainer)
           
        }
    }
}
