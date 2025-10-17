//
//  SocialLoginErrorPopup.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/15/25.
//

import SwiftUI

struct SocialLoginErrorPopup: View {
  let message: String
    let detail: String

  var body: some View {
    PopupCard {
      VStack(alignment: .leading, spacing: 10) {
        HStack(spacing: 8) {
          Image(systemName: "exclamationmark.triangle.fill")
            .font(.pretendardFont(family: .semiBold, size: 22))
            .foregroundColor(.red)
            .frame(width: 24, height: 24)

          Text("로그인 실패")
            .font(.pretendardFont(family: .semiBold, size: 18))
            .foregroundColor(.black)
          Spacer()
        }

        VStack(alignment: .leading, spacing: 6) {
          Text(message)
            .font(.pretendardFont(family: .medium, size: 16))
            .foregroundColor(.secondary)
            .multilineTextAlignment(.leading)


          Text(detail)
            .font(.pretendardFont(family: .medium, size: 14))
            .foregroundColor(.secondary)
            .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      .padding(.vertical, 10)
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}
