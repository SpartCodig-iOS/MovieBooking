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

  var body: some View {
    VStack(spacing: 10) {
      HeaderView(headerText: headerText)
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 15) {
          ForEach(movies) { movie in
            MovieCardView(movieTitle: movie.title, movieRating: Int(movie.voteAverage / 2), posterPath: movie.posterPath)
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

//#Preview {
//  MovieTypeSectionView(cardCount: 5, headerText: "Now Showing", movie: <#[Movie]#>)
//}
