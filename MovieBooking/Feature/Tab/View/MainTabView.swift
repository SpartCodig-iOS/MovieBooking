//
//  MainTabView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/16/25.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
  @Perception.Bindable var store: StoreOf<MainTabReducer>

  var body: some View {
    WithPerceptionTracking {
      TabView(selection: $store.selectTab) {
        ContentView()
          .tabItem { Label("홈", systemImage: "house") }
              .tag(MainTab.home)

        ContentView()
          .tabItem { Label("search", systemImage: "magnifyingglass") }
          .tag(MainTab.book)

        ContentView()
          .tabItem { Label("티켓", systemImage: "qrcode") }
          .tag(MainTab.tickets)

        ContentView()
          .tabItem { Label("마이", systemImage: "person") }
          .tag(MainTab.my)

      }
      .tint(.indigo500)
    }
  }
}


#Preview {
  MainTabView(store: Store(initialState: MainTabReducer.State(), reducer: {
    MainTabReducer()
  }))
}
