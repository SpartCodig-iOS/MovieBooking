//
//  Splash.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//


import Foundation
import ComposableArchitecture
import SwiftUI


@Reducer
public struct Splash {
  public init() {}

  @ObservableState
  public struct State: Equatable, Hashable {
    
    var fadeOut: Bool = false
    var pulse: Bool = false
    public init() {}
  }

  @CasePathable
  public enum Action: ViewAction, Equatable, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)

  }

  //MARK: - ViewAction
  @CasePathable
  public enum View : Equatable{
    case onAppear
    case startAnimationSequence

  }


  //MARK: - AsyncAction 비동기 처리 액션
  @CasePathable
  public enum AsyncAction: Equatable {

  }

  //MARK: - 앱내에서 사용하는 액션
  @CasePathable
  public enum InnerAction: Equatable {
    case setPulse(Bool)
    case setFadeOut(Bool)
  }

  //MARK: - NavigationAction
  @CasePathable
  public enum NavigationAction: Equatable {
    case presentLogin
    case presentMain


  }

  @Dependency(\.continuousClock) var clock

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .view(let viewAction):
          return handleViewAction(state: &state, action: viewAction)

        case .async(let asyncAction):
          return handleAsyncAction(state: &state, action: asyncAction)

        case .inner(let innerAction):
          return handleInnerAction(state: &state, action: innerAction)

        case .navigation(let navigationAction):
          return handleNavigationAction(state: &state, action: navigationAction)
      }
    }
  }
}

extension Splash {
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .onAppear:
        return .send(.view(.startAnimationSequence))

      case .startAnimationSequence:
        return .run { send in
          await send(.inner(.setPulse(true)))

          try await clock.sleep(for: .seconds(1.3))
          await send(.inner(.setFadeOut(true)))
          await send(.navigation(.presentLogin))
        }
    }
  }

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {

    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
        // 로그인 안했을경우
      case .presentLogin:
        return .none

        // 로그인 했을경우
      case .presentMain:
        return .none
    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {
      case .setPulse(let on):
        state.pulse = on
        return .none

      case .setFadeOut(let on):
        withAnimation(.easeInOut(duration: 3)) {
          state.fadeOut = on
        }
        return .none
    }
  }
}

