//
//  CustomAlert.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import SwiftUI

public extension View {
  func customAlert(
    isPresented: Bool,
    title: String,
    message: String,
    isUseConfirmButton: Bool = true,
    onConfirm: @escaping () -> Void,
    onCancel: @escaping () -> Void = {}
  ) -> some View {
    self.modifier(
      CustomAlertModifier(
        isPresented: isPresented,
        isUseConfirmButton: isUseConfirmButton, // ✅ 전달
        title: title,
        message: message,
        onConfirm: onConfirm,
        onCancel: onCancel
      )
    )
  }
}

struct CustomAlertModifier: ViewModifier {
  private let isPresented: Bool
  private let title: String
  private let message: String
  private let onConfirm: () -> Void
  private let onCancel: () -> Void
  private let isUseConfirmButton: Bool

  init(
    isPresented: Bool,
    isUseConfirmButton: Bool = true,
    title: String,
    message: String,
    onConfirm: @escaping () -> Void,
    onCancel: @escaping () -> Void = {}
  ) {
    self.isPresented = isPresented
    self.title = title
    self.message = message
    self.onConfirm = onConfirm
    self.isUseConfirmButton = isUseConfirmButton
    self.onCancel = onCancel
  }

  func body(content: Content) -> some View {
    content
      .overlay {
        Group {
          if isPresented {
            CustomAlert(
              title: title,
              message: message,
              isUseConfirmButton: isUseConfirmButton, 
              onConfirm: onConfirm,
              onCancel: onCancel
            )
            .transition(
              .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
              )
            )
            .zIndex(1)
          }
        }
      }
      .animation(.spring(response: 0.35, dampingFraction: 0.9, blendDuration: 0.1),
                 value: isPresented)
  }
}


struct CustomAlert: View {
  private let title: String
  private let message: String
  private let onConfirm: () -> Void
  private let onCancel: () -> Void
  private let isUseConfirmButton: Bool

  @State private var yOffset: CGFloat = 20 // ✅ 살짝 아래서 시작

  init(
    title: String,
    message: String,
    isUseConfirmButton: Bool = true,
    onConfirm: @escaping () -> Void,
    onCancel: @escaping () -> Void = {}
  ) {
    self.title = title
    self.message = message
    self.onConfirm = onConfirm
    self.onCancel = onCancel
    self.isUseConfirmButton = isUseConfirmButton
  }

  var body: some View {
    ZStack {
      Color.white.opacity(0.68)
        .ignoresSafeArea() // ✅

      VStack(alignment: .center, spacing: 24) {
        VStack(alignment: .center, spacing: 4) {
          Text(title)
            .pretendardFont(family: .bold, size: 20)
            .foregroundStyle(.textPrimary)

          Text(message)
            .pretendardFont(family: .regular, size: 14)
            .foregroundStyle(.textSecondary)
        }
        if isUseConfirmButton {
          Button {
            onConfirm()
          } label: {
            Text("확인")
              .pretendardFont(family: .medium, size: 14)
              .foregroundStyle(.white)
              .frame(maxWidth: .infinity)
              .frame(height: 38)
          }
          .background(.basicPurple)
          .clipShape(.rect(cornerRadius: 99))
          .contentShape(.rect(cornerRadius: 99))
        } else {
          HStack(spacing: 12) {
            Button {
              onCancel()
            } label: {
              Text("취소")
                .pretendardFont(family: .medium, size: 14)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
            }
            .background(.gray500)
            .clipShape(.rect(cornerRadius: 99))
            .contentShape(.rect(cornerRadius: 99))

            Button {
              onConfirm()
            } label: {
              Text("확인")
                .pretendardFont(family: .medium, size: 14)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
            }
            .background(.basicPurple)
            .clipShape(.rect(cornerRadius: 99))
            .contentShape(.rect(cornerRadius: 99))
          }
        }
      }
      .padding(.vertical, 36)
      .padding(.horizontal, 24)
      .background(.white)
      .clipShape(.rect(cornerRadius: 28))
      .overlay(
        RoundedRectangle(cornerRadius: 28)
          .stroke(.textPrimary.opacity(0.7), lineWidth: 1)
      )
      .shadow(radius: 10, y: 4)
      .offset(y: yOffset) // ✅ 진입 시 살짝 올라오게
      .onAppear {
        withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
          yOffset = 0
        }
      }
    }
  }
}


#Preview {
  CustomAlert(title: "테스터", message: "테스트", onConfirm: {}
  )
}
