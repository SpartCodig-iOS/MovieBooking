//
//  AuthCoordinatorView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import SwiftUI

import ComposableArchitecture
import TCACoordinators

public struct AuthCoordinatorView: View {
  @Perception.Bindable private var store: StoreOf<AuthCoordinator>

  public init(
    store: StoreOf<AuthCoordinator>
  ) {
    self.store = store
  }
  
  public var body: some View {
    TCARouter(store.scope(state: \.routes, action: \.router)) { screens in
      switch screens.case {
        case .login(let loginStore):
          LoginView(store: loginStore)
            .navigationBarBackButtonHidden()
          
        case .signUp(let signUpStore):
          SignUpView(store: signUpStore)
            .navigationBarBackButtonHidden()
          
          
      }
    }
  }
}
