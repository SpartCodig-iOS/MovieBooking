//
//  FormTextField.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/16/25.
//

import SwiftUI
import ComposableArchitecture

struct FormTextField: View {
  enum Kind { case text, email, password }

  let placeholder: String
  @Binding var text: String
  var kind: Kind = .text
  var error: String? = nil
  var helper: String? = nil
  var maxLength: Int? = nil
  var submitLabel: SubmitLabel = .done
  var onSubmit: (() -> Void)? = nil

  var isFocused: FocusState<Bool>.Binding? = nil

  // MARK: - Internal Focus
  @FocusState private var internalFocused: Bool
  @State var showPassword: Bool = false

  // MARK: - Body
  var body: some View {
    WithPerceptionTracking {
      VStack(alignment: .leading, spacing: 8) {
        ZStack {
          RoundedRectangle(cornerRadius: 12)
            .fill(.blueGray)

          RoundedRectangle(cornerRadius: 12)
            .strokeBorder(currentFocused ? .indigo500 : .clear, lineWidth: 2)
            .animation(.easeInOut(duration: 0.2), value: currentFocused)

          HStack(spacing: 8) {
            if kind == .password {
              Spacer().frame(width: 4)
            }

            // 입력 필드
            inputField
              .foregroundStyle(.textPrimary)
              .tint(.basicPurple)
              .submitLabel(submitLabel)
              .onSubmit { onSubmit?() }
              .onChange(of: text) { newValue in
                if let max = maxLength, newValue.count > max {
                  text = String(newValue.prefix(max))
                }
              }

            if kind == .password {
              Button {
                showPassword.toggle()
              } label: {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                  .foregroundStyle(.textSecondary)
                  .frame(width: 20, height: 20)
                  .contentShape(Rectangle())
              }
              .buttonStyle(.plain)
              .padding(.trailing, 12)
            }
          }
          .padding(.horizontal, 12)
        }
        .frame(height: 52)
        .contentShape(Rectangle())
        .onTapGesture { setFocus(true) }

        if let error, !error.isEmpty {
          Text(error)
            .font(.system(size: 12))
            .foregroundStyle(.statusError)
        } else if let helper, !helper.isEmpty {
          Text(helper)
            .font(.system(size: 12))
            .foregroundStyle(.gray500)
        }
      }
    }
  }

  // MARK: - Private helpers

  private var inputField: some View {
    Group {
      switch kind {
      case .password:
        if showPassword {
          TextField(placeholder, text: $text)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .applyFocus(focusBinding)
        } else {
          SecureField(placeholder, text: $text)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .applyFocus(focusBinding)
        }
      case .email:
        TextField(placeholder, text: $text)
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .keyboardType(.emailAddress)
          .applyFocus(focusBinding)
      case .text:
        TextField(placeholder, text: $text)
          .applyFocus(focusBinding)
      }
    }
  }

  private var focusBinding: FocusState<Bool>.Binding {
    isFocused ?? $internalFocused
  }

  private var currentFocused: Bool {
    (isFocused?.wrappedValue) ?? internalFocused
  }

  private func setFocus(_ value: Bool) {
    if let isFocused { isFocused.wrappedValue = value }
    else { internalFocused = value }
  }
}

// ✅ 작은 헬퍼: .focused(...)를 선택적으로 적용
private extension View {
  func applyFocus(_ binding: FocusState<Bool>.Binding) -> some View {
    self.focused(binding)
  }
}


#Preview() {
  FormTextField(placeholder: "tesx", text: .constant("") )
}
