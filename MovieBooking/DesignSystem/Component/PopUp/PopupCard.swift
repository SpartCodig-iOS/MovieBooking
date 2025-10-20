//
//  PopupCard.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import SwiftUI

struct PopupCard<Content: View>: View {
  let content: Content
  init(@ViewBuilder content: () -> Content) { self.content = content() }

  var body: some View {
    VStack(spacing: 10) {

      content
    }
    .padding(.vertical, 10)
    .padding(.horizontal, 10)
    .background(
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(Color(.systemBackground))
        .shadow(color: .black.opacity(0.12), radius: 16, y: 8)
    )
  }
}
