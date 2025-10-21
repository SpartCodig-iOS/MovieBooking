//
//  MovieSearchView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI
import ComposableArchitecture

struct MovieSearchView: View {
  @Perception.Bindable var store: StoreOf<MovieSearchFeature>

  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        SearchBar(text: $store.searchText)
          .padding(.bottom, 20)

        Group {
          if store.movies.isEmpty {
            EmptySearchView()
          } else {
            SearchView(movies: store.movies)
          }
        }
        .frame(maxHeight: .infinity)
      }
      .padding(.top, 20)
      .padding(.horizontal, 20)
    }
  }
}

#Preview {
  MovieSearchView(
    store: Store(
      initialState: MovieSearchFeature.State()
    ) {
      MovieSearchFeature()
    }
  )
}
