//
//  MyPageView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/17/25.
//

import SwiftUI
//TODO: 임시 타입 제거
struct User {
  let nickname: String
  let email: String
  let profileImage: String
  let loginType: LoginType
}

enum LoginType: String {
  case google = "Google"
  case apple = "Apple"
  case email = "Email"
  case kakao = "Kakao"
}

struct MyPageView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      VStack(alignment: .leading, spacing: 4){
        Text("내정보")
          .font(.system(size: 16))
        Text("프로필을 확인하세요")
          .font(.system(size: 14))
          .foregroundStyle(.gray)
      }

      ProfileBoxView(user: User(nickname: "11", email: "111@11.com", profileImage: "", loginType: .email))

      LogoutButton()

      Spacer()
    }
    .padding(.horizontal, 20)
    .padding(.top, 24)
  }
}

#Preview {
  MyPageView()
}
