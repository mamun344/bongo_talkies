//
//  MovieDetailsSectionView.swift
//  Bongo Talkies
//
//  Created by Admin on 8/11/22.
//

import SwiftUI

struct MovieDetailsSectionView: View {
    
    let header      : String?
    let contents    : [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let header {
                Text(header)
                    .font(Font.system(size: 13, weight: .semibold))
                    .foregroundColor(.textRegular)
            }
            
            Divider()
                .background(Color.divider)
            
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .top, spacing: 10) {
                    ForEach(contents, id: \.self) {
                        Text($0)
                            .font(Font.system(size: 13, weight: .regular))
                            .foregroundColor(.textRegular)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 10)
                            .background(Color.viewHighlight)
                            .clipped()
                            .cornerRadius(4)
                    }
                }
            }
        }
    }
}

