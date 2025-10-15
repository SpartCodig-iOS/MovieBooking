//
//  MovieListView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI
import ComposableArchitecture

struct MovieListView: View {
  let store: StoreOf<MovieListFeature>

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 20) {
        MovieTypeSectionView(cardCount: 5, headerText: "Now Showing", movies: store.movies)
        MovieTypeSectionView(cardCount: 4, headerText: "Coming Soon", movies: store.movies)
        MovieTypeSectionView(cardCount: 3, headerText: "전체 영화", movies: store.movies)
      }
    }
  }
}

#Preview {
  MovieListView(store: Store(initialState: MovieListFeature.State(movies: Movie.mockData)) {
    MovieListFeature()
  })
}
