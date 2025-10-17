//
//  MovieDetailView.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/16/25.
//

import SwiftUI

struct MovieDetailView: View {
    let posterPath: String

    var body: some View {
      ScrollView {
        VStack(spacing: 24) {
          MoviePosterView(posterPath: posterPath)

          MovieDetailCardView(model: .mockData)
            .padding(.horizontal, 24)
        }
      }
    }
}

#Preview {
  MovieDetailView(posterPath: "/bUrReoZFLGti6ehkBW0xw8f12MT.jpg")
}
