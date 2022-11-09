//
//  MovieListCellView.swift
//  Bongo Talkies
//
//  Created by Admin on 4/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct MovieListCellView: View {
  
    let movie   : Movie
    let height  : CGFloat

    
    var body: some View {
        if let path = movie.poster, path.count > 0 {
            ZStack(){
                WebImage(url: URL(string: APIUrl.moviePosterURL(quality: .w500, path: path)))
                    .resizable()
                    .placeholder(Image(.moviePlaceholder))
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
            }
            .frame(height: height)
            .clipped()
            .cornerRadius(15)
        }
        else {
            Image(.moviePlaceholder)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: height)
                .clipped()
                .cornerRadius(15)
        }
    }
}

