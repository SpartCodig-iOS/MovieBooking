//
//  SearchView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI

struct SearchView: View {
  let movies: [String] = ["1","2","3","4"]
  let columns: [GridItem] = [
    GridItem(.flexible()),
    GridItem(.flexible())
  ]

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("검색 결과 \(movies.count)개")
        .font(.system(size: 16))
        .frame(alignment: .leading)

      ScrollView {
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(movies, id: \.self) { _ in
            MovieCardView()
          }
        }
      }
    }
  }
}

#Preview {
  SearchView()
}
