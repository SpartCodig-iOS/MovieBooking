//
//  SignUpView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/16/25.
//

import SwiftUI
import ComposableArchitecture
internal import Auth
import Supabase

struct SignUpView: View {
  @Perception.Bindable var store: StoreOf<SignUpReducer>
  @FocusState private var focus: SignUpReducer.State.FocusedField?

  var body: some View {
    WithPerceptionTracking {
      VStack {
        Spacer()
          .frame(height: 10)

        navigationButton()

        Spacer()
          .frame(height: UIScreen.main.bounds.height * 0.03)

        ScrollView(.vertical) {
          VStack {

            signUpTitle()


            SignUpForm(store: store )

            Spacer()
              .frame(height: UIScreen.main.bounds.height * 0.17)

            confirmSignUpButton()

            Spacer()
              .frame(height: 20)

          }
        }
        .scrollIndicators(.hidden)
        .onAppear {
          UIScrollView.appearance().bounces = false

        }
      }
      .padding(.horizontal, 24)
    }
  }
}


extension SignUpView {
  @ViewBuilder
  private func navigationButton() -> some View {
    HStack {
      Image(systemName: "chevron.left")
        .foregroundStyle(.gray)
        .font(.pretendardFont(family: .medium, size: 20))
        .frame(width: 20, height: 20)
        .onTapGesture {
          store.send(.navigation(.backToLogin))
        }

      Spacer()
    }
  }

  @ViewBuilder
  private func signUpTitle() -> some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack {
        Text("회원가입")
          .font(.pretendardFont(family: .semiBold, size: 24))
          .foregroundStyle(.textPrimary)

        Spacer()
      }

      Text("회원 정보를 입력해주세요")
        .font(.pretendardFont(family: .medium, size: 16))
        .foregroundStyle(.textSecondary)
    }
    .padding(.vertical, 10)
  }

  @ViewBuilder
  private func confirmSignUpButton() -> some View {
    VStack {

      Button {
        Task { store.send(.async(.signUpUser)) }
      } label: {
        RoundedRectangle(cornerRadius: 12)
          .fill(store.isEnable ? .violet.opacity(0.6) : .lightLavender)
          .frame(height: 56)
          .overlay {
            Text("회원가입")
              .pretendardFont(family: .semiBold, size: 16)
              .foregroundStyle(.white)
          }
          .contentShape(RoundedRectangle(cornerRadius: 12))
      }
      .buttonStyle(.plain)
      .disabled(!store.isEnable)
    }
  }
}

#Preview {
  SignUpView(store: Store(initialState: SignUpReducer.State(), reducer: {
    SignUpReducer()
  }))
}
