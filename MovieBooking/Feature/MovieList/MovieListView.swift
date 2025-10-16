//
//  MovieListView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI
import ComposableArchitecture

struct MovieListView: View {
  @Perception.Bindable var store: StoreOf<MovieListFeature>

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 20) {
        MovieTypeSectionView(cardCount: 5, headerText: "Now Showing", movies: store.nowPlayingMovies)
        MovieTypeSectionView(cardCount: 4, headerText: "Coming Soon", movies: store.upcomingMovies)
        MovieTypeSectionView(cardCount: 3, headerText: "인기 영화", movies: store.popularMovies)
      }
    }
    .task {
      await store.send(.onAppear).finish()
    }
    .alert($store.scope(state: \.alert, action: \.alert))
  }
}

//#Preview {
//  MovieListView(store: Store(initialState: MovieListFeature.State(movies: Movie.mockData)) {
//    MovieListFeature()
//  })
//}
