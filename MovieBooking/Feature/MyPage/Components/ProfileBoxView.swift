//
//  ProfileBoxView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/17/25.
//

import SwiftUI

struct ProfileBoxView: View {
  let user: UserEntity
  
  var body: some View {
    HStack {
      VStack(alignment: .leading ,spacing: 12) {
        HStack {
          if user.provider == .kakao || user.provider == .google  {
            Circle()
              .fill(.lavenderPurple)
              .frame(width: 64, height: 64)
              .overlay {
                Image(user.provider.image)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 32, height: 32)
                  .foregroundStyle(.white)
              }

          } else {
            Circle()
              .fill(.lavenderPurple)
              .frame(width: 64, height: 64)
              .overlay {
                Image(systemName: user.provider.image)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 32, height: 32)
                  .foregroundStyle(.white)
              }
          }

          VStack {
            HStack {
              Text(user.displayName ?? "")
                .font(.pretendardFont(family: .medium, size: 16))
                .foregroundStyle(.textPrimary)

              Spacer()
            }

            HStack {
              Text(user.email ?? "")
                .font(.pretendardFont(family: .medium, size: 14))
                .foregroundStyle(.gray500)

              Spacer()
            }

            HStack {
              LoginTypeView(type: user.provider)

              Spacer()
            }
          }

          Spacer()
        }
        .padding(.horizontal, 20)

//        Divider()
//          .padding(.horizontal, 24)
//          .padding(.vertical, 26)

      }
      .padding(.vertical, 24)
      .frame(maxWidth: .infinity)
      .background(.white)
      .cornerRadius(16)
      .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
  }
}

#Preview {
  ProfileBoxView(
    user: .mockAppleUser
  )
}
