//
//  MovieCardView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI

struct MovieCardView: View {
  let movieTitle: String
  let movieRating: Int

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Image("movie")
        .resizable()
        .scaledToFit()
        .frame(width: 150, height: 200)
        .background(.cyan)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 3, y: 3)

      Text(movieTitle)
        .font(.system(size: 16))
        .frame(width: 150, alignment: .leading)
        .lineLimit(1)

      StarRatingView(rating: movieRating)
    }
  }
}

#Preview {
  MovieCardView(movieTitle: "mvTitle", movieRating: 4)
}
