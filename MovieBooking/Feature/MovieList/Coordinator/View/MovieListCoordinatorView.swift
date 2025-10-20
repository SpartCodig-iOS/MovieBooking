//
//  MovieListCoordinatorView.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/20/25.
//

import SwiftUI
import ComposableArchitecture
import TCACoordinators

public struct MovieListCoordinatorView: View {
  @Perception.Bindable private var store: StoreOf<MovieListCoordinator>

  public init(
    store: StoreOf<MovieListCoordinator>
  ) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store.scope(state: \.routes, action: \.router)) { screens in
      switch screens.case {
      case .list(let store):
        MovieListView(store: store)
      case .detail(let store):
        MovieDetailView(store: store)
      case .book(let store):
        MovieBookView(store: store)
      }
    }
  }
}

#Preview {
  MovieListCoordinatorView(store: Store(initialState: MovieListCoordinator.State(), reducer: {
    MovieListCoordinator()
  }))
}
