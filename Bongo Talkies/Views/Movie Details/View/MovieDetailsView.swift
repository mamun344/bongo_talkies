//
//  MovieDetailsView.swift
//  Bongo Talkies
//
//  Created by Admin on 5/11/22.
//

import SwiftUI
import SDWebImageSwiftUI
import AlertToast

struct MovieDetailsView: View {
    
    @EnvironmentObject var device           : Device
    @ObservedObject private var viewModel   : MovieDetailsViewModel

    @State private var padding              : CGFloat = 12.0
    @State var updater: Bool = false

    
    init(movie: Movie){
        let apiService = APIManager()
        viewModel = MovieDetailsViewModel(movie: movie, apiService: apiService)
    }
    

    var body: some View {
            ZStack (alignment: .top) {
                Color.viewBG
                
                VStack(spacing: 0){
                    ScrollView {
                        VStack(spacing: 0){
                            bannerView
                            
                            summaryView
                                .padding(.top, 25)
                            
                            overviewView
                                .padding(.top, 30)
                            
                            detailsView
                                .padding(.top, 40)
                        }
                        .padding(.horizontal, padding)
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                    }
                    
                    Rectangle().frame(height: Router.safeAreaBottom)
                        .foregroundColor(.viewBG)
                }
            }
            .onChange(of: device.isLandscape){ newValue in
                prepareUI()
            }
            .onChange(of: device.connected){ newValue in                
                if newValue == true {
                    viewModel.refresh(internet: newValue)
                }
            }
            .toast(isPresenting: $viewModel.showAlert){
                AlertToast(type: .regular, title: viewModel.alertMessage)
            }
            .onAppear(){
                prepareUI()
                viewModel.refresh(internet: device.connected)
            }
            .ignoresSafeArea(.container, edges: [.bottom, .leading, .trailing])
            .navigationBar(title: Titles.movieDetails)
    }
    
    
    @ViewBuilder
    private var bannerView: some View {
        if let path = viewModel.movieDetails.backdrop, path.count > 0 {
            WebImage(url: URL(string: APIUrl.moviePosterURL(quality: .w500, path: path)))
                .resizable()
                .placeholder(Image(.moviePlaceholderLands))
                .aspectRatio(contentMode: .fill)
                .scaledToFit()
                .clipped()
                .cornerRadius(15)
            
        }
        else {
            Image(.moviePlaceholderLands)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaledToFill()
                .clipped()
                .cornerRadius(15)
        }
    }
    
    @ViewBuilder
    private var summaryView: some View {
        VStack(alignment: .leading, spacing: 10){
            Text((viewModel.movieDetails.title ?? "").uppercased())
                .font(Font.system(size: 17, weight: .bold))
                .foregroundColor(.textRegular)
            
            HStack(alignment: .top, spacing: 0){
                Text("Ratting | \(viewModel.movieDetails.averageVoteRounded ?? "")")
                    .font(Font.system(size: 12, weight: .regular))
                    .foregroundColor(.textRegular)
                
                Spacer()
                
                Text("Total Votes | \(viewModel.movieDetails.totalVote ?? 0)")
                    .font(Font.system(size: 12, weight: .regular))
                    .foregroundColor(.textRegular)
            }
            
            MovieDetailsSectionView(header: nil, contents: ["Run Time : \(viewModel.movieDetails.runTimeString ?? "")", "Released : \(viewModel.movieDetails.releaseDateFormattedString ?? "")", "Adult : \((viewModel.movieDetails.isAdult ?? false) ? "Yes" : "No")"])
        }
    }
    
    @ViewBuilder
    private var overviewView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("OVERVIEW")
                .font(Font.system(size: 13, weight: .semibold))
                .foregroundColor(.textRegular)
            
            Divider()
                .background(Color.divider)

            Text(viewModel.movieDetails.overview ?? "")
                    .font(Font.system(size: 13, weight: .regular))
                    .foregroundColor(.textRegular)
        }
    }
    
    @ViewBuilder
    private var detailsView: some View {
        VStack(spacing: 30){
            MovieDetailsSectionView(header: "BUSINESS", contents: viewModel.businessInfo)

            MovieDetailsSectionView(header: "LANGUAGE", contents: viewModel.languages)

            MovieDetailsSectionView(header: "GENRES", contents: viewModel.genres)
            
            MovieDetailsSectionView(header: "PRODUCTION COMPANIES", contents: viewModel.companies)
            
            MovieDetailsSectionView(header: "PRODUCTION COUNTRIES", contents: viewModel.countries)
        }
    }
    
    private func prepareUI(){
        if UIDevice.current.userInterfaceIdiom == .phone {
            padding = device.isLandscape ? 30 : 12.0
        }
        else {
            padding = device.isLandscape ? 30.0 : 22
        }
    }
}

