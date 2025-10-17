//
//  EmptySearchView.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI

struct EmptySearchView: View {
  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "magnifyingglass")
        .font(.system(size: 40))
        .foregroundColor(.purple)
        .padding(20)
        .background(Color.purple.opacity(0.1))
        .clipShape(Circle())

      Text("영화를 검색해보세요")
        .font(.headline)
        .foregroundColor(.black)

      Text("보고싶은 영화를 찾아보세요")
        .font(.subheadline)
        .foregroundColor(.gray)
    }
    .multilineTextAlignment(.center)
  }
}

#Preview {
  EmptySearchView()
}
