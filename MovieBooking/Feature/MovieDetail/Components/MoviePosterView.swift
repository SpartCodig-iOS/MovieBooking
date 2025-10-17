//
//  MoviePosterView.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/16/25.
//

import SwiftUI

struct MoviePosterView: View {
  private let posterPath: String
  
  init(posterPath: String) {
    self.posterPath = posterPath
  }

  var body: some View {
    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { phase in
      switch phase {
      case .success(let image):
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
      case .failure:
        Color.red
          .overlay(
            Text("Failed to load image")
              .foregroundColor(.white)
          )
      case .empty:
        ProgressView()
      @unknown default:
        EmptyView()
      }
    }
    .frame(width: 250, height: 250)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 8)
  }
}

#Preview {
  MoviePosterView(posterPath: "/bUrReoZFLGti6ehkBW0xw8f12MT.jpg")
}
