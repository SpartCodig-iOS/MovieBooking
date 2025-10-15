//
//  LoginView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import SwiftUI

import ComposableArchitecture

public struct LoginView: View {
  @Perception.Bindable var store: StoreOf<Login>

  init(store: StoreOf<Login>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      Spacer()

      loginLogo

      loginTitle()

      Spacer()
    }

  }
}

extension LoginView {
  private var loginLogo: some View {
    RoundedRectangle(cornerRadius: 24, style: .continuous)
      .fill(
        LinearGradient(
          colors: [
            .basicPurple,
            .violet
          ],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .frame(width: 120, height: 120)
      .shadow(color: .basicPurple.opacity(0.3), radius: 16, x: 0, y: 8)
      .overlay(
        Image(systemName: "film.fill")
          .font(.pretendardFont(family: .medium, size: 48))
          .foregroundColor(.white)
      )
  }

  @ViewBuilder
  private func loginTitle() -> some View {
    VStack(spacing: 6) {
      Text("MEGABOX")
        .font(.pretendardFont(family: .semiBold, size: 32))
        .foregroundColor(.primary)

      Text("간편하게 로그인하고 예매를 시작하세요")
        .font(.pretendardFont(family: .medium, size: 16))
        .foregroundColor(.secondary)
    }
  }
}


#Preview {
  LoginView(store: .init(initialState: Login.State(), reducer: {
    Login()
  }))
}


