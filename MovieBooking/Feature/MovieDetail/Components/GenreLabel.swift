//
//  GenreLabel.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import SwiftUI

struct GenreLabel: View {
  let genre: Genre
  
  var body: some View {
    Text(genre.name)
      .font(.caption)
      .foregroundColor(.primary)
      .padding(.vertical, 4)
      .padding(.horizontal, 8)
      .background(Color.purple.opacity(0.2))
      .clipShape(Capsule())
      .overlay(
        Capsule()
          .stroke(Color.purple.opacity(0.5), lineWidth: 1)
      )
  }
}

#Preview {
  GenreLabel(genre: Genre(id: 0, name: "Drama"))
}
