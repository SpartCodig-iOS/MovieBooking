//
//  MainTabReducer.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/16/25.
//

import Foundation
import ComposableArchitecture


@Reducer
public struct MainTabReducer {
  public init() {}

  @ObservableState
  public struct State: Equatable {

    var selectTab: MainTab = .home
    public init() {}
  }

  public enum Action : BindableAction{
    case binding(BindingAction<State>)
    case selectTab(MainTab)

  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding(_):
          return .none

        case .selectTab(let tab):
          state.selectTab = tab
          return .none
      }
    }
  }
}

extension MainTabReducer.State: Hashable {
  public static func == (lhs: MainTabReducer.State, rhs: MainTabReducer.State) -> Bool {
    lhs.selectTab == rhs.selectTab
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(selectTab)
  }
}
