//
//  AppView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import SwiftUI

import ComposableArchitecture

struct AppView: View {
  @Perception.Bindable var store: StoreOf<AppReducer>

  var body: some View {
    SwitchStore(store) { state in
      switch state {
      case .splash:
        if let store = store.scope(state: \.splash, action: \.scope.splash) {
          SplashView(store: store)
        }

      case .auth:
        if let store = store.scope(state: \.auth, action: \.scope.auth) {
          AuthCoordinatorView(store: store)
        }
      }
    }
  }
}
