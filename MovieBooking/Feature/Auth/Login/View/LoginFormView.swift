//
//  LoginFormView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/15/25.
//

import ComposableArchitecture
import SwiftUI
import Perception

struct LoginFormView: View {
  @Perception.Bindable var store: StoreOf<LoginFeature>

  @FocusState private var focus: LoginFeature.State.FocusedField?

  

  var body: some View {
    VStack(spacing: 16) {
      FormTextField(
        placeholder: "아이디를 입력하세요",
        text: $store.loginId.sending(\.loginId),
        kind: .email,
        submitLabel: .next,
        onSubmit: { focus = .password },
      )
      .focused($focus, equals: .id)

      FormTextField(
        placeholder: "비밀번호를 입력하세요",
        text: $store.loginPassword.sending(\.loginPassword),
        kind: .password,
        submitLabel: .done,
      )
      .focused($focus, equals: .password)

      HStack {
        Checkbox(isOn: $store.saveUserId)
        Text("아이디 저장")
          .font(.pretendardFont(family: .medium, size: 16))
          .foregroundStyle(.secondary)

        Spacer()
      }

      Button {
        Task {
           store.send(.inner(.setSocialType(.email)))
           store.send(.async(.normalLogin))
        }
      } label: {
        Text("로그인")
          .foregroundStyle(.white)
          .font(.pretendardFont(family: .bold, size: 20))
          .frame(maxWidth: .infinity, minHeight: 56)
          .background(
            RoundedRectangle(cornerRadius: 20)
              .fill(store.isEnable ? .violet.opacity(0.6) : .lightLavender)
          )
      }
      .disabled(!store.isEnable)
    }
  }
}


#Preview() {
  LoginFormView(store: Store(initialState: LoginFeature.State(userEntity: .init()), reducer: {
    LoginFeature()
  }))
}

