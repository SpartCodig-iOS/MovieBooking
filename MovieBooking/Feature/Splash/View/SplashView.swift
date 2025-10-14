//
//  SplashView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import SwiftUI
import ComposableArchitecture

struct SplashView: View {
  @Bindable var store: StoreOf<Splash>

  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [
          .white,
          .white,
          .megaboxPrimary.opacity(0.05)
        ]),
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()

      VStack(spacing: 24) {

        splashLogo()

        titleView()
      }
      .scaleEffect(store.fadeOut ? 0.95 : 1.0)
      .opacity(store.fadeOut ? 0.0 : 1.0)
      .animation(.easeInOut(duration: 1), value: store.fadeOut)
      .onAppear {
        store.send(.view(.onAppear))
      }

    }
  }
}


extension SplashView {

  @ViewBuilder
  fileprivate func splashLogo() -> some View {
    ZStack {
      Circle()
        .fill(.megaboxPrimary.opacity(0.20))
        .blur(radius: 24)
        .scaleEffect(store.pulse ? 1.08 : 0.95)
        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: store.pulse)

      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(
          LinearGradient(
            colors: [
              .megaboxPrimary,
              Color.purple
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 10)
        .frame(width: 120, height: 120)
        .overlay(
          Image(systemName: "film.fill")
            .pretendardFont(family: .medium, size: 48)
            .foregroundColor(.white)
        )
    }
  }

  @ViewBuilder
  fileprivate func titleView() -> some View {
    VStack(spacing: 6) {
      Text("MEGABOX")
        .pretendardFont(family: .semiBold, size: 32)
        .foregroundColor(.primary)

      Text("나만의 영화관, 지금 시작합니다 🎬")
        .pretendardFont(family: .medium, size: 16)
        .foregroundColor(.secondary)
    }
  }
}


#Preview {
  SplashView(store: .init(initialState: Splash.State(), reducer: {
    Splash()
  }))
}
