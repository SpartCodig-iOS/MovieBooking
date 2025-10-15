//
//  AuthCoordinatorView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import SwiftUI

import ComposableArchitecture
import TCACoordinators

 struct AuthCoordinatorView: View {
  @Perception.Bindable private var store: StoreOf<AuthCoordinator>

   init(
    store: StoreOf<AuthCoordinator>
  ) {
    self.store = store
  }

   var body: some View {
    WithPerceptionTracking {
      TCARouter(store.scope(state: \.routes, action: \.router)) { screens in
        switch screens.case {
        case .login(let loginStore):
          LoginView(store: loginStore)
            .navigationBarBackButtonHidden()


        }
      }
    }
  }
}
