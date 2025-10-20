//
//  MainTabView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/16/25.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
  @Perception.Bindable var store: StoreOf<MainTabFeature>
  
  var body: some View {
    WithPerceptionTracking {
      TabView(selection: $store.selectTab) {
        MovieListCoordinatorView(
          store: self.store.scope(
            state: \.movieCoordinator,
            action: \.scope.movieCoordinator
          )
        )
        .tabItem { Label("홈", systemImage: "house") }
        .tag(MainTab.home)
        
        MovieSearchView(store: self.store.scope(state: \.movieSearch, action: \.scope.movieSearch))
          .tabItem { Label("search", systemImage: "magnifyingglass") }
          .tag(MainTab.book)
        
        BookingListView(store: self.store.scope(state: \.ticket, action: \.scope.ticket))
          .tabItem { Label("티켓", systemImage: "qrcode") }
          .tag(MainTab.tickets)
        
        MyPageView(store: self.store.scope(state: \.myPage, action: \.scope.myPage))
          .tabItem { Label("마이", systemImage: "person") }
          .tag(MainTab.my)
        
      }
      .tint(.indigo500)
    }
  }
}


#Preview {
  MainTabView(store: Store(initialState: MainTabFeature.State(), reducer: {
    MainTabFeature()
  }))
}
