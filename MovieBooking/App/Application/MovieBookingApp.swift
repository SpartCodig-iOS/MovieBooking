//
//  MovieBookingApp.swift
//  MovieBooking
//
//  Created by 김민희 on 10/13/25.
//

import SwiftUI
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
        }
    }
}
