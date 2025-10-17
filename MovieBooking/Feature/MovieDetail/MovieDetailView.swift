//
//  MovieDetailView.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/16/25.
//

import SwiftUI

struct MovieDetailView: View {
  var body: some View {
    ScrollView {
      VStack(spacing: 24) {
        if let path = MovieDetail.mockData.posterPath {
          MoviePosterView(posterPath: path)
        }
        
        MovieDetailCardView(model: .mockData)
          .padding(.horizontal, 24)
      }
    }
  }
}

#Preview {
  MovieDetailView()
}
