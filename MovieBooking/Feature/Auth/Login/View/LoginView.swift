//
//  LoginView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import ComposableArchitecture
import Supabase
import SwiftUI
import AuthenticationServices

public struct LoginView: View {
  @Bindable var store: StoreOf<Login>
  private let repo = AuthRepositoryImpl()

  init(store: StoreOf<Login>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      Spacer()

      loginLogo

      loginTitle()

      socialLoginButtonCard()

      Spacer()
    }
    .floatingPopup(
      isPresented: $store.showErrorPopUp,
      alignment: .top,                // .center / .top 도 가능
//      tapOutsideToDismiss: true,
//      backgroundOpacity: 0.3
    ) {
      SocialLoginErrorPopup()
    }

  }
}

extension LoginView {
  fileprivate var loginLogo: some View {
    RoundedRectangle(cornerRadius: 24, style: .continuous)
      .fill(
        LinearGradient(
          colors: [
            .basicPurple,
            .basicPurple,
          ],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .frame(width: 120, height: 120)
      .shadow(color: .basicPurple.opacity(0.3), radius: 16, x: 0, y: 8)
      .overlay(
        Image(systemName: "film.fill")
          .foregroundColor(.white)
      )
  }

  @ViewBuilder
  fileprivate func loginTilte() -> some View {
    VStack(spacing: 6) {
      Text("MEGABOX")
        .font(.pretendardFont(family: .semiBold, size: 32))
        .foregroundColor(.primary)

      Text("간편하게 로그인하고 예매를 시작하세요")
        .font(.pretendardFont(family: .medium, size: 16))
        .foregroundColor(.secondary)

      Spacer()
        .frame(height: 18)
    }
  }

  @ViewBuilder
  func socialLoginButtonCard() -> some View {
    VStack(spacing: 24) {
      ZStack {
        Divider().background(Color.gray.opacity(0.2))
        Text("소셜 계정으로 로그인")
          .pretendardFont(family: .medium, size: 16)
          .foregroundStyle(.gray)
          .padding(.horizontal, 12)
          .background(.white)
      }
      .padding(.top, 4)

      VStack(spacing: 12) {
        ForEach(SocialType.allCases.filter { $0 != .none}) { type in
          socialLoginButton(type: type) {

          }
        }
      }
    }
    .padding(24)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(.white)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(.gray.opacity(0.1), lineWidth: 1)
    )
    .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
    .padding(.horizontal, 24)
  }


  @ViewBuilder
  fileprivate func socialLoginButton(
    type: SocialType,
    onTap: @escaping () -> Void
  ) -> some View {
    if type == .apple {
      ZStack {
        HStack {
          Spacer()
          Image(systemName: type.image)
            .resizable().scaledToFit()
            .frame(width: 20, height: 20)
            .foregroundStyle(.white)
          Spacer().frame(width: 12)
          Text(type.title)
            .pretendardFont(family: .medium, size: 16)
            .foregroundStyle(.white)
          Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, minHeight: 56)
        .background(Color.black)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)

        SignInWithAppleButton(.signIn) { request in
          store.send(.async(.prepareAppleRequest(request)))
        } onCompletion: { result in
          store.send(.async(.appleCompletion(result)))
        }
        .frame(height: 56)
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .cornerRadius(12)
        .opacity(0.02)
        .accessibilityLabel(Text(type.title))
        .allowsHitTesting(true)
      }

    } else {
      Button(role: .none) {
        onTap()
      } label: {
        HStack {
          Spacer()
          Image(type.image)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)

          Spacer()
            .frame(width: 12)

          Text(type.title)
            .pretendardFont(family: .medium, size: 16)
            .foregroundStyle(type.textColor)

          Spacer()
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, minHeight: 56)
        .background(type.color)
        .cornerRadius(12)
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.gray.opacity(type.hasBorder ? 0.25 : 0),
                    lineWidth: type.hasBorder ? 2 : 0)
        )
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
      }
      .buttonStyle(.plain)
      .contentShape(RoundedRectangle(cornerRadius: 12))
    }
  }

  @ViewBuilder
  func SocialLoginErrorPopup(message: String = "소셜 로그인에 인증에 실패하셨습니다.") -> some View {
    PopupCard {
      HStack(alignment: .top, spacing: 12) {
        Image(systemName: "exclamationmark.triangle.fill")
          .font(.system(size: 18, weight: .semibold))
          .foregroundColor(.red)

        VStack(alignment: .leading, spacing: 8) {
          Text("로그인 실패")
            .font(.headline)

          Text(message)
            .font(.subheadline)
            .foregroundColor(.secondary)

          Text("잠시 후 다시 시도하거나, 다른 소셜 계정으로 시도해 주세요.")
            .font(.footnote)
            .foregroundColor(.secondary)
        }

      Spacer()
      }
    }
  }
}

#Preview {
  LoginView(
    store: .init( initialState: Login.State(), reducer: {
        Login()
      }
    )
  )
}


