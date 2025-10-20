//
//  MyPageView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/17/25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: MyPageFeature.self)
struct MyPageView: View {
  @Perception.Bindable var store: StoreOf<MyPageFeature>

  var body: some View {
    WithPerceptionTracking {
      VStack(alignment: .leading, spacing: 24) {
        VStack(alignment: .leading, spacing: 4){
          Text("내정보")
            .font(.pretendardFont(family: .semiBold, size: 16))
            .foregroundStyle(.black)

          Text("프로필을 확인하세요")
            .font(.pretendardFont(family: .medium, size: 14))
            .foregroundStyle(.textPrimary)
        }

        ProfileBoxView(user: store.userEntity)

        LogoutButton{
          send(.tapLogOut)
        }

        Spacer()

        appVersionText()

        Spacer()
          .frame(height: 10)
      }
      .padding(.top, 24)
    }
    .customAlert(
      isPresented: store.appearPopUp,
      title: "로그아웃",
      message: "정말 로그아웃하시겠어요?",
      isUseConfirmButton: false,
      onConfirm: {
        Task {
           store.send(.async(.logOutUser))
        }
      },
      onCancel: {
        send(.closePopUp)
      }
    )
    .padding(.horizontal, 24)
  }
}

#Preview {
  MyPageView(store: Store(initialState: MyPageFeature.State(), reducer: {
    MyPageFeature()
  }))
}


extension MyPageView {
  @ViewBuilder
  fileprivate func appVersionText() -> some View {
    VStack {
      HStack{
        Spacer()
        Text("앱 버전 1.0.0")
          .font(.pretendardFont(family: .semiBold, size: 16))
          .foregroundStyle(.textSecondary)
        Spacer()
      }
    }
  }
}
