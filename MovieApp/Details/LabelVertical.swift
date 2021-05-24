//
//  LabelVertical.swift
//  MovieApp
//
//  Created by Hossam on 24/05/2021.
//

import SwiftUI
struct LabelVertical : View{
    let systemImage : String
    let title : String
    var body: some View {
        VStack(spacing:8){
            Image(systemName: systemImage)
            Text(title)
    
        }
        .frame(width: 75)
    }
    
    
}
