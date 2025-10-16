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
  let movies: [Movie]
  @State private var currentIndex: Int = 0

  var body: some View {
    VStack(spacing: 10) {
      HeaderView(
        headerText: headerText,
        onLeftTapped: {
          if currentIndex > 0 {
            currentIndex -= 1
          }
        },
        onRightTapped: {
          if currentIndex < movies.count - 1 {
            currentIndex += 1
          }
        }
      )
      ScrollViewReader { proxy in
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 15) {
            ForEach(movies) { movie in
              MovieCardView(
                movieTitle: movie.title,
                movieRating: Int(movie.voteAverage / 2),
                posterPath: movie.posterPath
              )
              .id(movie.id)
            }
          }
        }
        .onChange(of: currentIndex) { newIndex in
          withAnimation {
            proxy.scrollTo(movies[newIndex].id, anchor: .leading)
          }
        }
      }
    }
    .padding(.horizontal, 20)
  }
}

struct HeaderView: View {
  let headerText: String
  let onLeftTapped: () -> Void
  let onRightTapped: () -> Void

  var body: some View {
    HStack(spacing: 10) {
      Text(headerText)
        .font(.system(size: 16))

      Spacer()

      CircularArrowButton(direction: .left, action: onLeftTapped)

      CircularArrowButton(direction: .right, action: onRightTapped)
    }
  }
}

//#Preview {
//  MovieTypeSectionView(cardCount: 5, headerText: "Now Showing", movie: <#[Movie]#>)
//}
