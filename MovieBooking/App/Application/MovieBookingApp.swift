//
//  MovieBookingApp.swift
//  MovieBooking
//
//  Created by 김민희 on 10/13/25.
//

import SwiftUI
import Supabase
import ComposableArchitecture

@main
struct MovieBookingApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  init() {

  }

  var body: some Scene {
    WindowGroup {
      let store = Store(initialState: AppReducer.State()) {
        AppReducer()
          ._printChanges()
          ._printChanges(.actionLabels)
      }

      AppView(store: store)
        .onOpenURL { url in
          Task {
            try await SuperBaseManger.shared.client.auth.session(from: url)
          }
        }
    }
  }
}
