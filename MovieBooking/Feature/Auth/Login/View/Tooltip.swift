//
//  Tooltip.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/15/25.
//

import SwiftUI

struct Tooltip: View {
  let text: String

  var body: some View {
    VStack(spacing: 0) {
      Text(text)
        .font(.pretendardFont(family: .medium, size: 12))
        .foregroundColor(.primary)
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .fixedSize(horizontal: true, vertical: false)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(.white)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )

      Triangle()
        .offset(x: -20)
        .fill(.white)
        .frame(width: 12, height: 6)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .rotationEffect(.degrees(180))
    }
  }
}


struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.closeSubpath()
    return path
  }
}

struct ToolTipAnchorKey: PreferenceKey {
  static var defaultValue: Anchor<CGRect>? = nil
  static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {

    if let next = nextValue() { value = next }
  }
}


#Preview("말풍선") {
  Tooltip(text: "마지막에 로그인한")
}

