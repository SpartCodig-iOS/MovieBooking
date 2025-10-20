//
//  LogoutButton.swift
//  MovieBooking
//
//  Created by 김민희 on 10/17/25.
//

import SwiftUI

public  struct LogoutButton: View {
  var action: () -> Void = { }

  init(
    action: @escaping () -> Void
  ) {
    self.action = action
  }

  public var body: some View {
    Button {
      action()
    } label: {
      HStack(spacing: 8) {
        Image(systemName: "rectangle.portrait.and.arrow.right")
          .font(.pretendardFont(family: .semiBold, size: 14))

        Text("로그아웃")
          .foregroundStyle(.white)
          .font(.pretendardFont(family: .semiBold, size: 16))
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
  LogoutButton(action: {})
}
