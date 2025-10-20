//
//  LoginTypeView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/17/25.
//

import SwiftUI

struct LoginTypeView: View {
  let type: SocialType

  var body: some View {
    HStack {
      if type == .kakao || type == .google {
        Image(type.image)
          .resizable()
          .scaledToFit()
          .frame(width: 15, height: 15)
      } else {
        Image(systemName: type.image)
          .resizable()
          .scaledToFit()
          .frame(width: 15, height: 15)
          .foregroundStyle(.white)
      }

      Text(type.description)
        .font(.pretendardFont(family:.medium, size: 14))
        .fontWeight(.bold)
        .foregroundColor(.white)
    }
    .padding(.vertical, 6)
    .padding(.horizontal, 15)
      .background(.black)
      .clipShape(Capsule())
  }
}

#Preview() {
  LoginTypeView(type: .apple)
}
