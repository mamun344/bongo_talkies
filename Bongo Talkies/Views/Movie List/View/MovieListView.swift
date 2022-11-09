//
//  MovieListView.swift
//  Bongo Talkies
//
//  Created by Admin on 4/11/22.
//

import SwiftUI
import AlertToast

struct MovieListView: View {
    
    @EnvironmentObject var device           : Device
    @ObservedObject private var viewModel   : MovieListViewModel
    
    @State private var showNextView         : Bool = false
    
    @State private var padding              : CGFloat = 0.0
    @State private var horizontalGap        : CGFloat = 0.0
    @State private var verticalGap          : CGFloat = 0.0
    @State private var cellHeight           : CGFloat = 0.0
    
    @State private var columns              : [GridItem] = []
    
    
    init(){
        let apiService = APIManager()
        viewModel = MovieListViewModel(apiService: apiService)
    }
    
    
    var body: some View {
        NavigationView {
            ZStack (alignment: .center) {
                Color.viewBG
                
                VStack(spacing: 0){
                    if viewModel.movies.count > 0 {
                        ScrollView {
                            listView
                        }
                    }
                    else {
                        if let error = viewModel.errorMessage, error.count > 0 {
                            errorView
                        }
                        else if viewModel.fetchedOnce {
                            noMovieView
                        }
                        else if viewModel.isLoading {
                            loadingView
                        }
                    }
                    
                    Rectangle().frame(height: Router.safeAreaBottom)
                        .foregroundColor(.viewBG)
                }
                
                
                
                NavigationLink(destination: detailsView, isActive: $showNextView) {
                    Spacer()
                }
            }
            .onChange(of: device.isLandscape){ newValue in
                prepareUI()
            }
            .onChange(of: device.connected){ newValue in
                viewModel.hasInternet = newValue
                
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
            .ignoresSafeArea(.container, edges: [.bottom, .trailing])
            .navigationBar(title: Titles.topMovies, hasBack: false)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    private func prepareUI(){
        var noOfColumns = 0
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            noOfColumns = device.isLandscape ? 3 : 2
            padding = device.isLandscape ? 30 : 12.0
            horizontalGap = 12.0
            verticalGap = 12.0
        }
        else {
            noOfColumns = device.isLandscape ? 4 : 3
            padding = device.isLandscape ? 50 : 30.0
            horizontalGap = 25.0
            verticalGap = 25.0
        }
        
        let cellWidth = (device.screenWidth - 2.0 * padding - verticalGap) / CGFloat(noOfColumns)
        cellHeight = (cellWidth * 4.0) / 3.0
        
        columns = (0..<noOfColumns-1).map { _ in
            var item = GridItem(.fixed(cellWidth))
            item.spacing = verticalGap
            return item
        }
        
        columns.append(GridItem(.fixed(cellWidth)))
    }
    
    
    @ViewBuilder
    private var listView : some View {
        VStack(spacing: 0) {
            LazyVGrid(columns: columns, spacing: horizontalGap) {
                ForEach(viewModel.movies.indexed(), id: \.1.id) { index, movie in
                    
                    MovieListCellView(movie: movie, height: cellHeight)
                        .onTapGesture {
                            viewModel.selectedIndex = index
                            showNextView = true
                        }
                        .onAppear(){
                            viewModel.loadNextPageIfPossible(movie)
                        }
                }
            }
            .padding(.top, 10)
            
            if viewModel.isLoading {
                Text(Titles.loadingMore)
                    .font(Font.system(size: 12, weight: .regular))
                    .foregroundColor(.navTitle)
                    .padding(.vertical, 15)
            }
        }
        .padding(.horizontal, padding)
        
    }
    
    
    @ViewBuilder
    private var detailsView : some View {
        if showNextView, let selectedMovie = viewModel.selectedMovie {
            MovieDetailsView(movie: selectedMovie).environmentObject(device)
        }
    }
    
    @ViewBuilder
    private var errorView : some View {
        VStack(spacing: 20){
            Text(viewModel.errorMessage ?? "")
                .font(Font.system(size: 14))
                .foregroundColor(.gray)
                .padding(.top, 20)
            
            Button {
                viewModel.refresh(internet: device.connected)
            } label: {
                Text(Titles.tryAgain)
                    .font(Font.system(size: 15))
                    .foregroundColor(.gray)
                    .frame(height: 35)
                    .padding(.horizontal, 30)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1))
            }
        }
        .padding(.horizontal, padding)
    }
    
    @ViewBuilder
    private var noMovieView : some View {
        Text(Titles.noMovieFound)
            .font(Font.system(size: 16))
            .foregroundColor(.gray)
            .padding(.top, 20)
            .padding(.horizontal, padding)
    }
    
    @ViewBuilder
    private var loadingView : some View {
        Text(Titles.loading)
            .font(Font.system(size: 14))
            .foregroundColor(.gray)
            .padding(.top, 20)
            .padding(.horizontal, padding)
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
