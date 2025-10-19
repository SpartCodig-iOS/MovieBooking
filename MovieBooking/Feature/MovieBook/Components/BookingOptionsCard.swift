//
//  BookingOptionsCard.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import SwiftUI

struct BookingOptionsCard: View {
  let theaters: [MovieTheater]
  let showTimes: [ShowTime]
  @Binding var selectedTheater: MovieTheater?
  @Binding var selectedShowTime: ShowTime?
  @Binding var numberOfPeople: Int

  var body: some View {
    VStack(spacing: 20) {
      // 극장 선택
      SelectionListView(
        title: "극장",
        items: theaters,
        selectedItem: selectedTheater,
        onSelect: { selectedTheater = $0 },
        placeholder: "극장을 선택해주세요",
        displayText: { $0.name }
      )

      // 상영시간 선택
      SelectionListView(
        title: "상영시간",
        items: showTimes,
        selectedItem: selectedShowTime,
        onSelect: { selectedShowTime = $0 },
        placeholder: "상영시간을 선택해주세요",
        displayText: { "\($0.displayShortDate) \($0.time)" }
      )
      .disabled(selectedTheater == nil)
      .opacity(selectedTheater == nil ? 0.5 : 1.0)

      // 인원수 선택
      SelectionListView(
        title: "인원수",
        items: Array(1...10),
        selectedItem: numberOfPeople,
        onSelect: { numberOfPeople = $0 },
        displayText: { "\($0)명" }
      )
    }
    .padding(20)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
  }
}

// MARK: - Preview
#Preview {
  BookingOptionsCardPreview()
}

private struct BookingOptionsCardPreview: View {
  @State var selectedTheater: MovieTheater? = MovieTheater(id: 1, name: "CGV 강남")
  @State var selectedShowTime: ShowTime? = ShowTime(date: Date(), time: "14:30")
  @State var numberOfPeople = 1

  var body: some View {
    BookingOptionsCard(
      theaters: [
        MovieTheater(id: 1, name: "CGV 강남"),
        MovieTheater(id: 2, name: "메가박스 코엑스"),
        MovieTheater(id: 3, name: "롯데시네마 월드타워"),
        MovieTheater(id: 4, name: "CGV 용산")
      ],
      showTimes: [
        ShowTime(date: Date(), time: "10:00"),
        ShowTime(date: Date(), time: "12:30"),
        ShowTime(date: Date(), time: "14:30"),
        ShowTime(date: Date(), time: "17:00"),
        ShowTime(date: Date(), time: "19:30"),
        ShowTime(date: Date(), time: "22:00")
      ],
      selectedTheater: $selectedTheater,
      selectedShowTime: $selectedShowTime,
      numberOfPeople: $numberOfPeople
    )
    .padding()
  }
}
