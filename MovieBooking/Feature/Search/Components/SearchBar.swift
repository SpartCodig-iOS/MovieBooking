//
//  SearchBar.swift
//  MovieBooking
//
//  Created by 김민희 on 10/14/25.
//

import SwiftUI

struct SearchBar: View {
  @Binding var text: String

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 30)
        .stroke(.gray.opacity(0.4), lineWidth: 1)

      HStack(spacing: 10) {
        Image(systemName: "magnifyingglass")
          .foregroundColor(.gray)
          .font(.system(size: 18, weight: .semibold))
          .padding(.leading, 8)

        TextField("영화 제목을 검색하세요", text: $text)
          .font(.system(size: 18, weight: .semibold))
          .frame(maxWidth: .infinity)

        if !text.isEmpty {
          Button {
            self.text = ""
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundStyle(.gray.opacity(0.6))
              .font(.system(size: 18, weight: .semibold))
              .padding(.trailing, 15)
          }
        }
      }
      .padding(.horizontal, 10)
    }
    .frame(height: 50)
  }
}

#Preview {
  @Previewable @State var text = ""
  SearchBar(text: $text)
}
