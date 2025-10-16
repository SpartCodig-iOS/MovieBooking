//
//  SignUpForm.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/16/25.
//

import SwiftUI
import ComposableArchitecture

struct SignUpForm: View {
  @Perception.Bindable var store: StoreOf<SignUpReducer>
 

  @FocusState private var focus: SignUpReducer.State.FocusedField?

  var body: some View {
    VStack(spacing: 16) {
      FormTextField(
        title: "이름",
        placeholder: "이름 입력하세요",
        text: $store.userName,
        kind: .text,
        error: store.userNameError,
        submitLabel: .next,
        onSubmit: { focus = .email }
      )
      .focused($focus, equals: .name)
      .onChange(of: store.userName) {_ in
        store.userNameError = FieldValidator.validateName(store.userName)
      }

      FormTextField(
        title: "이메일",
        placeholder: "이메일 입력하세요",
        text: $store.userEmail,
        kind: .email,
        error: store.userEmailError,
        submitLabel: .next,
        onSubmit: { focus = .password },
      )
      .focused($focus, equals: .email)
      .onChange(of: store.userEmail) {_ in
        store.userEmailError = FieldValidator.validateEmail(store.userEmail)
      }


      FormTextField(
        title: "비밀번호",
        placeholder: "비밀번호 입력하세요",
        text: $store.userPassword,
        kind: .password,
        error: store.passwordError,
        submitLabel: .next,
        onSubmit: { focus = .checkPassword },
      )
      .focused($focus, equals: .password)
      .onChange(of: store.userPassword) {_ in
        store.passwordError = FieldValidator.validatePassword(store.userPassword)
      }

      FormTextField(
        title: "비밀번호 확인",
        placeholder: "비밀번호 입력하세요",
        text: $store.checkPassword,
        kind: .password,
        error: store.checkPasswordError,
        submitLabel: .next,
      )
      .focused($focus, equals: .checkPassword)
      .onChange(of: store.checkPassword) {_ in
        store.checkPasswordError = FieldValidator.validateConfirm(store.userPassword, store.checkPassword,)
      }
    }
  }
}



