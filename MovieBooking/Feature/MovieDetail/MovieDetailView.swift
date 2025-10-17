//
//  MovieDetailView.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/16/25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: MovieDetailFeature.self)
struct MovieDetailView: View {
  @Perception.Bindable var store: StoreOf<MovieDetailFeature>

  var body: some View {
    Group {
      if store.isLoading {
        ProgressView("영화 정보 로딩 중...")
      } else if let movieDetail = store.movieDetail {
        ScrollView {
          VStack(spacing: 24) {
            if let path = movieDetail.posterPath {
              MoviePosterView(posterPath: path)
            }

            MovieDetailCardView(model: movieDetail)
              .padding(.horizontal, 24)
          }
        }
      } else {
        Text("영화 정보를 불러올 수 없습니다")
          .foregroundColor(.secondary)
      }
    }
    .onAppear {
      send(.onAppear)
    }
  }
}

#Preview {
  MovieDetailView(
    store: Store(
      initialState: MovieDetailFeature.State(movieId: 2)
    ) {
      MovieDetailFeature()
    }
  )
}
