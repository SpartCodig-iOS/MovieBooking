//
//  TitledDivider.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import SwiftUI

struct TitledDivider: View {
  var title: String
  var lineColor: Color = .gray.opacity(0.2)
  var textColor: Color = .gray
  var lineHeight: CGFloat = 1

  var body: some View {
    HStack(spacing: 8) {
      Rectangle()
        .fill(lineColor)
        .frame(height: lineHeight)
        .frame(maxWidth: .infinity)

      Text(title)
        .pretendardFont(family: .medium, size: 16)
        .foregroundStyle(textColor)
        .padding(.horizontal, 8)
        .fixedSize()

      Rectangle()
        .fill(lineColor)
        .frame(height: lineHeight)
        .frame(maxWidth: .infinity)
    }
    .frame(maxWidth: .infinity)
  }
}
