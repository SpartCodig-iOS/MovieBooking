//
//  MyPageFeature.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import Foundation
import ComposableArchitecture
import WeaveDI


@Reducer
public struct MyPageFeature {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    @Shared(.inMemory("UserEntity")) var userEntity: UserEntity = .mockEmailUser
    var appearPopUp: Bool = false

    public init() {}
  }

  public enum Action: ViewAction, BindableAction {
    case binding(BindingAction<State>)
    case view(View)
    case async(AsyncAction)
    case inner(InnerAction)
    case navigation(NavigationAction)

  }

  //MARK: - ViewAction
  @CasePathable
  public enum View {
    case tapLogOut
    case appearPopUp(Bool)
    case closePopUp
  }

  //MARK: - AsyncAction 비동기 처리 액션
  public enum AsyncAction: Equatable {
    case logOutUser
  }

  //MARK: - 앱내에서 사용하는 액션
  public enum InnerAction: Equatable {
  }

  //MARK: - NavigationAction
  public enum NavigationAction: Equatable {
    case logOutComplete

  }

  nonisolated enum MyPageCancelID: Hashable, Sendable {
    case logOut
  }

  @Injected(AuthUseCase.self) var authUseCase
  @Dependency(\.continuousClock) var clock
  @Dependency(\.mainQueue) var mainQueue

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

extension MyPageFeature {
  private func handleViewAction(
    state: inout State,
    action: View
  ) -> Effect<Action> {
    switch action {
      case .tapLogOut:
        return .run { send in
          await send(.view(.appearPopUp(true)))
        }

      case .appearPopUp(let bool):
        state.appearPopUp = bool
        return .none

      case .closePopUp:
        state.appearPopUp = false
        return .none
    }
  }

  private func handleAsyncAction(
    state: inout State,
    action: AsyncAction
  ) -> Effect<Action> {
    switch action {
      case .logOutUser:
        return .run { send in
          try await authUseCase.sessionLogOut()
          try await clock.sleep(for: .seconds(0.3))
          await send(.view(.closePopUp))
          try await clock.sleep(for: .seconds(0.4))
          await send(.navigation(.logOutComplete))

        }
        .debounce(id: MyPageCancelID.logOut, for: 0.1, scheduler: mainQueue)
    }
  }

  private func handleNavigationAction(
    state: inout State,
    action: NavigationAction
  ) -> Effect<Action> {
    switch action {
      case .logOutComplete:
        return .none
    }
  }

  private func handleInnerAction(
    state: inout State,
    action: InnerAction
  ) -> Effect<Action> {
    switch action {

    }
  }
}


extension MyPageFeature.State: Hashable {
  public static func == (lhs: MyPageFeature.State, rhs: MyPageFeature.State) -> Bool {
    lhs.userEntity == rhs.userEntity &&
    rhs.appearPopUp == lhs.appearPopUp
  }
  public func hash(into hasher: inout Hasher) {
    hasher.combine(userEntity)
    hasher.combine(appearPopUp)

  }
}
