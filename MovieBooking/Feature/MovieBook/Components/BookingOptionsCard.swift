//
//  BookingOptionsCard.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import SwiftUI

struct BookingOptionsCard: View {
  let theaters: [String]
  let times: [String]
  @Binding var selectedTheater: String
  @Binding var selectedTime: String
  @Binding var numberOfPeople: Int

  var body: some View {
    VStack(spacing: 20) {
      // 극장 선택
      CustomPickerRow(
        title: "극장",
        selection: $selectedTheater,
        options: theaters
      )

      // 상영시간 선택
      CustomPickerRow(
        title: "상영시간",
        selection: $selectedTime,
        options: times
      )

      // 인원수 선택
      CustomPickerRow(
        title: "인원수",
        selection: $numberOfPeople,
        options: Array(1...10),
        displayFormatter: { "\($0)명" }
      )
    }
    .padding(20)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
  }
}

// MARK: - Custom Picker Row
fileprivate struct CustomPickerRow<T: Hashable>: View {
  let title: String
  @Binding var selection: T
  let options: [T]
  var displayFormatter: ((T) -> String)?

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(.system(size: 16, weight: .semibold))

      Menu {
        ForEach(options, id: \.self) { option in
          Button {
            selection = option
          } label: {
            HStack {
              Text(displayText(for: option))
              if selection == option {
                Spacer()
                Image(systemName: "checkmark")
                  .foregroundColor(.basicPurple)
              }
            }
          }
        }
      } label: {
        HStack {
          Text(displayText(for: selection))
            .foregroundColor(.primary)
            .font(.system(size: 16))

          Spacer()

          Image(systemName: "chevron.down")
            .font(.system(size: 14))
            .foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
          RoundedRectangle(cornerRadius: 14)
            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
      }
    }
  }

  private func displayText(for option: T) -> String {
    if let formatter = displayFormatter {
      return formatter(option)
    }
    return "\(option)"
  }
}

#Preview {
  BookingOptionsCardPreview()
}

private struct BookingOptionsCardPreview: View {
  @State var selectedTheater = "CGV 강남"
  @State var selectedTime = "14:30"
  @State var numberOfPeople = 1

  var body: some View {
    BookingOptionsCard(
      theaters: ["CGV 강남", "메가박스 코엑스", "롯데시네마 월드타워", "CGV 용산"],
      times: ["10:00", "12:30", "14:30", "17:00", "19:30", "22:00"],
      selectedTheater: $selectedTheater,
      selectedTime: $selectedTime,
      numberOfPeople: $numberOfPeople
    )
    .padding()
  }
}
