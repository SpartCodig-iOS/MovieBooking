//
//  CircularArrowButton.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI

enum ArrowDirection {
  case left
  case right
}

struct CircularArrowButton: View {
  private let direction: ArrowDirection
  private let action: () -> Void

  init(direction: ArrowDirection, action: @escaping () -> Void) {
    self.direction = direction
    self.action = action
  }

  private var systemImageName: String {
    switch self.direction {
    case .left:
      return "chevron.left"
    case .right:
      return "chevron.right"
    }
  }

  var body: some View {
    Button(action: action) {
      ZStack {
        Circle()
          .stroke(.gray.opacity(0.4), lineWidth: 1)

        Image(systemName: systemImageName)
          .font(.system(size: 10, weight: .semibold))
          .foregroundStyle(.black)
      }
      .frame(width: 30, height: 30)
    }
  }
}
