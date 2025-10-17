//
//  MovieSearchView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI

struct MovieSearchView: View {
  @State private var searchText = ""

  var body: some View {
    VStack(spacing: 20) {
      SearchBar(text: $searchText)

      SearchView(movies: Movie.mockData)
    }
    .padding(.horizontal, 20)
  }
}

#Preview {
  MovieSearchView()
}
