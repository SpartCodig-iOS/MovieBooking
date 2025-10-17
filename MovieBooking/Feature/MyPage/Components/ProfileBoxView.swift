//
//  ProfileBoxView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/17/25.
//

import SwiftUI

struct ProfileBoxView: View {
  let user: User

  var body: some View {
    VStack(spacing: 12) {
      Image(user.profileImage)
        .resizable()
        .scaledToFit()
        .frame(width: 100, height: 100)
        .background(.basicPurple)
        .clipShape(Circle())

      Text(user.nickname)
        .font(.system(size: 16))

      Text(user.email)
        .font(.system(size: 14))
        .foregroundStyle(.gray)

      LoginTypeView(type: user.loginType)

      Divider()
        .padding(.horizontal, 24)
        .padding(.vertical, 26)

      HStack(spacing: 32) {
        BookingCountView(count: 2, state: "총 예매")
        BookingCountView(count: 0, state: "관람 예정")
      }
    }
    .padding(.vertical, 24)
    .frame(maxWidth: .infinity)
    .background(.white)
    .cornerRadius(16)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
  }
}

struct LoginTypeView: View {
  let type: LoginType

  var body: some View {
    Text(type.rawValue)
      .font(.system(size: 14))
      .fontWeight(.bold)
      .foregroundColor(.white)
      .padding(.vertical, 6)
      .padding(.horizontal, 15)
      .background(Color.black)
      .clipShape(Capsule())
  }
}

struct BookingCountView: View {
  let count: Int
  let state: String

  var body: some View {
    VStack(spacing: 4) {
      Text("\(count)")
        .font(.system(size: 20))
        .foregroundStyle(.basicPurple)

      Text(state)
        .font(.system(size: 12))
        .foregroundStyle(.gray)

    }
  }
}

#Preview {
  ProfileBoxView(user: User(nickname: "11", email: "11@11.com", profileImage: "", loginType: .apple))
}
