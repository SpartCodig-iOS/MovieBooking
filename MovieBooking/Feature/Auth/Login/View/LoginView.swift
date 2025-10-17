//
//  LoginView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import SwiftUI

import AuthenticationServices

import ComposableArchitecture
import Supabase

@ViewAction(for: LoginFeature.self)
struct LoginView: View {
  @Perception.Bindable var store: StoreOf<LoginFeature>

  var body: some View {
    WithPerceptionTracking {
      @Perception.Bindable var store = store

      ScrollView {
        LazyVStack {

          Spacer()
            .frame(height: UIScreen.main.bounds.height * 0.15)

          loginLogo

          loginTilte()


          LoginFormView(store: store)

          socialLoginButtonCard(currentSocialType: store.socialType)

          authFooter()


          Spacer()
            .frame(height: 10)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 24)
      }
      .scrollIndicators(.hidden)
      .scrollBounceBehavior(.basedOnSize)
      .ignoresSafeArea(.keyboard)
      .task {
        send(.onAppear)
      }
      .onAppear {
        UIScrollView.appearance().bounces = false
      }

      .floatingPopup(
        isPresented: $store.showErrorPopUp.sending(\.showErrorPopUp),
        alignment: .top
      ) {
        WithPerceptionTracking {
          SocialLoginErrorPopup(
            message: store.authErrorMesage ?? "",
            detail: store.authError ?? ""
          )
        }
      }
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
          .font(.pretendardFont(family: .medium, size: 48))
          .foregroundColor(.white)
      )
  }

  @ViewBuilder
  fileprivate func loginTilte() -> some View {
    VStack(spacing: 6) {
      Text("TicketSwift ")
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
  func socialLoginButtonCard(currentSocialType: SocialType?) -> some View {
    let current = currentSocialType

    LazyVStack {
      VStack(spacing: 24) {
        TitledDivider(title: "소셜 계정으로 로그인")
          .frame(maxWidth: .infinity, alignment: .center)

        HStack(spacing: 20) {
          ForEach(SocialType.allCases.filter { $0 != .none && $0 != .email }) { type in
            let isSelected = (current == type)

            socialCircleButton(type: type, lastSocialLogin: type) {
              store.send(.async(.signInWithSocial(social: type)))
            }
            .anchorPreference(key: ToolTipAnchorKey.self, value: .bounds) { anchor in
              isSelected ? anchor : nil
            }
          }
        }
        .frame(maxWidth: .infinity)
        .overlayPreferenceValue(ToolTipAnchorKey.self) { anchor in
          GeometryReader { proxy in
            WithPerceptionTracking {
              if let a = anchor {
                let rect = proxy[a]
                Tooltip(text: "마지막에 로그인한 계정이에요!")
                  .position(x: rect.midX - 18, y: rect.minY - 20)
              }
            }
          }
        }
      }
      .padding(10)
      .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
    }
  }

  @ViewBuilder
  private func socialCircleButton(
    type: SocialType,
    lastSocialLogin: SocialType,
    onTap: @escaping () -> Void
  ) -> some View {
    WithPerceptionTracking {
      let circleSize: CGFloat = 56

      switch type {
        case .apple:
          ZStack {
            Circle()
              .fill(.black)
              .frame(width: circleSize, height: circleSize)
              .shadow(color: .black.opacity(0.08), radius: 8, y: 2)

            Image(systemName: type.image)
              .resizable()
              .scaledToFit()
              .frame(width: 22, height: 22)
              .foregroundStyle(.white)

            SignInWithAppleButton(.signIn) { request in
              store.send(.async(.prepareAppleRequest(request)))
            } onCompletion: { result in
              store.send(.async(.appleCompletion(result)))
            }
            .frame(width: circleSize, height: circleSize)
            .clipShape(Circle())
            .opacity(0.02)
            .allowsHitTesting(true)
          }

        case .google:
          Button(action: onTap) {
            Circle()
              .fill(Color.white)
              .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
              .frame(width: circleSize, height: circleSize)
              .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
              .overlay(
                Image(type.image)
                  .resizable().scaledToFit()
                  .frame(width: 22, height: 22)
              )
          }
          .buttonStyle(.plain)

        case .kakao:
          Button(action: onTap) {
            Circle()
              .fill(.brightYellow)
              .frame(width: circleSize, height: circleSize)
              .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
              .overlay(
                Image(type.image)
                  .resizable().scaledToFit()
                  .frame(width: 40, height: 40)
                  .foregroundStyle(.black)
              )
          }
          .buttonStyle(.plain)

        default:
          EmptyView()
      }
    }
  }

  @ViewBuilder
  private func authFooter() -> some View {
    VStack {
      HStack {
        Text("아직 회원이 아니신가요?")
          .font(.pretendardFont(family: .medium, size: 14))
          .foregroundColor(.secondary)


        Text("회원가입")
          .font(.pretendardFont(family: .semiBold, size: 14))
          .foregroundColor(.basicPurple)
          .onTapGesture {
            store.send(.navigation(.signUpRequested))
          }
      }
    }
    .padding(.vertical, 8)
  }
}

#Preview {
  LoginView(
    store: .init( initialState: LoginFeature.State(userEntity: .init()), reducer: {
      LoginFeature()}
                )
  )
}
