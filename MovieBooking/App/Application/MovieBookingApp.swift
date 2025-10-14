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
    var body: some Scene {
        WindowGroup {
          SplashScreenView(store: Store(initialState: Splash.State(), reducer: {
            Splash()
          }))
        }
    }
}
