//
//  MovieTypeSectionView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI

struct MovieTypeSectionView: View {
  let cardCount: Int
  let headerText: String

  var body: some View {
    VStack(spacing: 10) {
      HeaderView(headerText: headerText)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15) {
          ForEach(0..<cardCount, id: \.self) { _ in
            MovieCardView()
          }
        }
      }
    }
    .padding(.horizontal, 20)
  }
}

struct HeaderView: View {
  let headerText: String

  var body: some View {
    HStack(spacing: 10) {
      Text(headerText)
        .font(.system(size: 16))

      Spacer()

      CircularArrowButton(direction: .left) {
        print("left")
      }

      CircularArrowButton(direction: .right) {
        print("right")
      }
    }
  }
}

#Preview {
  MovieTypeSectionView(cardCount: 5, headerText: "Now Showing")
}
