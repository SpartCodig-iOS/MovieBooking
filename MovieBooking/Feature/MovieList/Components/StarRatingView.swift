//
//  StarRatingView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI

struct StarRatingView: View {
  private let rating: Int

  init(rating: Int) {
    self.rating = rating
  }

  var body: some View {
    HStack(spacing: 4) {
      ForEach(1...5, id: \.self) { index in
        Image(systemName: "star.fill")
          .resizable()
          .scaledToFit()
          .frame(width: 12, height: 12)
          .foregroundColor(index <= rating ? .yellow : .gray)
      }
    }
  }
}
