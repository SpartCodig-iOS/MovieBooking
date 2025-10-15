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
  let posterPath: String?

  private var imageURL: URL? {
    guard let path = posterPath else { return nil }
    return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      AsyncImage(url: imageURL) { phase in
        switch phase {
        case .empty:
          ZStack {
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.gray.opacity(0.2))
            ProgressView()
          }
          .frame(width: 150, height: 200)

        case .success(let image):
          image
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 3, y: 3)

        case .failure:
          ZStack {
            RoundedRectangle(cornerRadius: 10)
              .fill(Color.gray.opacity(0.3))
            Image(systemName: "film")
              .font(.system(size: 40))
              .foregroundColor(.gray)
          }
          .frame(width: 150, height: 200)

        @unknown default:
          EmptyView()
        }
      }

      Text(movieTitle)
        .font(.system(size: 16))
        .frame(width: 150, alignment: .leading)
        .lineLimit(1)

      StarRatingView(rating: movieRating)
    }
  }
}

#Preview {
  MovieCardView(movieTitle: "mvTitle", movieRating: 4, posterPath: nil)
}
