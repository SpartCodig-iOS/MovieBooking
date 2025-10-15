//
//  MovieListFeature.swift
//  MovieBooking
//
//  Created by 김민희 on 10/15/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieListFeature {
  @ObservableState
  public struct State {
    var movies: [Movie] = []
    var isLoading = false
  }

  enum Action {
    case onAppear
    case fetchMovie
    case selectMovie
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none

      case .fetchMovie:
        return .none

      case .selectMovie:
        //TODO: 상세로 넘어감
        return .none
      }
    }
  }
}
