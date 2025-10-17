//
//  LogoutButton.swift
//  MovieBooking
//
//  Created by 김민희 on 10/17/25.
//

import SwiftUI

struct LogoutButton: View {
  var body: some View {
    Button {
      print("로그아웃 버튼이 눌렸습니다!")
    } label: {
      HStack(spacing: 8) {
        Image(systemName: "rectangle.portrait.and.arrow.right")
          .font(.system(size: 14, weight: .semibold))

        Text("로그아웃")
          .font(.system(size: 14, weight: .semibold))
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .background(.basicPurple)
      .foregroundColor(.white)
      .clipShape(Capsule())
    }
    .padding(.vertical, 16)
  }
}

#Preview {
  LogoutButton()
}
