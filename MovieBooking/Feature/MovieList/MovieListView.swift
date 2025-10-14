//
//  MovieListView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI

struct MovieListView: View {
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 20) {
        MovieTypeSectionView(cardCount: 5, headerText: "Now Showing")
        MovieTypeSectionView(cardCount: 4, headerText: "Coming Soon")
        MovieTypeSectionView(cardCount: 3, headerText: "전체 영화")
      }
    }
  }
}

#Preview {
  MovieListView()
}
