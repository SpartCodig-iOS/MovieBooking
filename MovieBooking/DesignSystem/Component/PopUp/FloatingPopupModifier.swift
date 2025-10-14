//
//  FloatingPopupModifier.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import SwiftUI

struct FloatingPopupModifier<PopupContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  var alignment: Alignment = .bottom
  var tapOutsideToDismiss: Bool = true
  var backgroundOpacity: Double = 0.25
  var animation: Animation = .spring(response: 0.35, dampingFraction: 0.9)
  var autoDismissDelay: Double = 2.5 // true가 되고 2.5초 뒤 자동 false
  var popupContent: () -> PopupContent

  func body(content: Content) -> some View {
    content
      .overlay {
        ZStack(alignment: .center) {
          if isPresented {
            // Dim 배경
            Color.black.opacity(backgroundOpacity)
              .ignoresSafeArea()
              .contentShape(Rectangle())
              .onTapGesture {
                if tapOutsideToDismiss {
                  withAnimation(animation) { isPresented = false }
                }
              }
              .transition(.opacity)

            // 팝업 카드
            popupContent()
              .frame(maxWidth: 560)
              .padding(.horizontal, 20)
              .padding(.bottom, safeAreaBottomPadding())
              .transition(.asymmetric(
                insertion: .move(edge: edgeFor(alignment)).combined(with: .opacity),
                removal: .move(edge: edgeFor(alignment)).combined(with: .opacity)
              ))
            // ✅ 외부에서 true로 바뀔 때 자동 dismiss 타이머만 실행
              .onChange(of: isPresented) { newValue in
                if newValue {
                  DispatchQueue.main.asyncAfter(deadline: .now() + autoDismissDelay) {
                    if isPresented {
                      withAnimation(animation) { isPresented = false }
                    }
                  }
                }
              }
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
          }
        }
        .animation(animation, value: isPresented)
        .zIndex(999)
      }
  }

  private func edgeFor(_ alignment: Alignment) -> Edge {
    switch alignment {
      case .top: return .top
      case .bottom: return .bottom
      default: return .bottom
    }
  }

  private func safeAreaBottomPadding() -> CGFloat {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first?.keyWindow?.safeAreaInsets.bottom ?? 0
  }
}
extension View {
  func floatingPopup<PopupContent: View>(
    isPresented: Binding<Bool>,
    alignment: Alignment = .bottom,
    tapOutsideToDismiss: Bool = true,
    backgroundOpacity: Double = 0.25,
    animation: Animation = .spring(response: 0.35, dampingFraction: 0.9),
    @ViewBuilder content: @escaping () -> PopupContent
  ) -> some View {
    modifier(FloatingPopupModifier(
      isPresented: isPresented,
      alignment: alignment,
      tapOutsideToDismiss: tapOutsideToDismiss,
      backgroundOpacity: backgroundOpacity,
      animation: animation,
      popupContent: content
    ))
  }
}
