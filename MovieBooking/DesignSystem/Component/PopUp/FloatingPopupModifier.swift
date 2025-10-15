//
//  FloatingPopupModifier.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import SwiftUI

import SwiftUI

struct FloatingPopupModifier<PopupContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  var alignment: Alignment = .bottom
  var tapOutsideToDismiss: Bool = true
  var backgroundOpacity: Double = 0.25
  var animation: Animation = .spring(response: 0.35, dampingFraction: 0.9)
  var autoDismissDelay: Double = 2.5   // true가 되고 2.5초 뒤 자동 false
  var popupContent: () -> PopupContent

  @State private var isVisible: Bool = false          // 실제로 렌더링 중인지
  @State private var dismissTask: Task<Void, Never>?  // 자동 닫힘 타이머

  func body(content: Content) -> some View {
    content
      .overlay(alignment: .center) {
        ZStack {
          if isVisible {
            // Dim 배경
            Color.black
              .opacity(isPresented ? backgroundOpacity : 0)
              .ignoresSafeArea()
              .contentShape(Rectangle())
              .onTapGesture {
                guard tapOutsideToDismiss else { return }
                withAnimation(animation) { isPresented = false }
              }
              .transition(.opacity)
              .allowsHitTesting(isPresented) // 닫히는 중엔 터치 막기

            // 팝업 카드
            popupContent()
              .frame(maxWidth: 560)
              .padding(.horizontal, 20)
              .padding(.bottom, safeAreaBottomPadding())
              .transition(
                .asymmetric(
                  insertion: .move(edge: edgeFor(alignment)).combined(with: .opacity),
                  removal: .move(edge: edgeFor(alignment)).combined(with: .opacity)
                )
              )
              .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
          }
        }
        .animation(animation, value: isPresented)
        .animation(animation, value: isVisible)
        .onChange(of: isPresented) { newValue in
          if newValue {
            // 등장
            withAnimation(animation) { isVisible = true }
            // 자동 닫힘 예약 (기존 예약 취소)
            dismissTask?.cancel()
            dismissTask = Task { @MainActor in
              try? await Task.sleep(nanoseconds: UInt64(autoDismissDelay * 1_000_000_000))
              guard !Task.isCancelled else { return }
              withAnimation(animation) { isPresented = false }
            }
          } else {
            // 사라짐: isPresented가 false가 되면 트랜지션 태우고 렌더링 제거
            dismissTask?.cancel()
            withAnimation(animation) { isVisible = false }
          }
        }
        .onAppear {
          // 최초 동기화
          isVisible = isPresented
          if isPresented {
            dismissTask?.cancel()
            dismissTask = Task { @MainActor in
              try? await Task.sleep(nanoseconds: UInt64(autoDismissDelay * 1_000_000_000))
              guard !Task.isCancelled else { return }
              withAnimation(animation) { isPresented = false }
            }
          }
        }
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
    autoDismissDelay: Double = 2.5,
    @ViewBuilder content: @escaping () -> PopupContent
  ) -> some View {
    modifier(
      FloatingPopupModifier(
        isPresented: isPresented,
        alignment: alignment,
        tapOutsideToDismiss: tapOutsideToDismiss,
        backgroundOpacity: backgroundOpacity,
        animation: animation,
        autoDismissDelay: autoDismissDelay,
        popupContent: content
      )
    )
  }
}
