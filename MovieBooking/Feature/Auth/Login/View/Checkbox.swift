//
//  Checkbox.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/15/25.
//

import SwiftUI

struct Checkbox: View {
  @Binding var isOn: Bool

  var body: some View {
    Button {
      isOn.toggle()
    } label: {
      Image(systemName: isOn ? "checkmark.square.fill" : "square")
        .resizable()
        .frame(width: 22, height: 22)
        .foregroundStyle(.basicPurple)
    }
    .buttonStyle(.plain)
  }
}
