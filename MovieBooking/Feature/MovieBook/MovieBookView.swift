//
//  MovieBookView.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import SwiftUI

struct MovieBookView: View {
    let posterPath: String
    let title: String
    let pricePerTicket: Int = 13000

    @State private var selectedTheater: String = "CGV 강남"
    @State private var selectedTime: String = "14:30"
    @State private var numberOfPeople: Int = 1

    private let theaters = ["CGV 강남", "메가박스 코엑스", "롯데시네마 월드타워", "CGV 용산"]
    private let times = ["10:00", "12:30", "14:30", "17:00", "19:30", "22:00"]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
              // 극장/시간/인원 선택 카드
              BookingOptionsCard(
                  theaters: theaters,
                  times: times,
                  selectedTheater: $selectedTheater,
                  selectedTime: $selectedTime,
                  numberOfPeople: $numberOfPeople
              )
                // 결제 정보 카드
                PaymentInfoCard(
                    posterPath: posterPath,
                    title: title,
                    pricePerTicket: pricePerTicket,
                    numberOfPeople: numberOfPeople,
                    onPaymentTapped: handlePayment
                )
            }
            .padding(24)
        }
    }

    private func handlePayment() {
        print("결제하기 버튼 눌림")
        print("극장: \(selectedTheater)")
        print("시간: \(selectedTime)")
        print("인원: \(numberOfPeople)명")
        print("총액: ₩\((pricePerTicket * numberOfPeople).formatted())")
    }
}

#Preview {
  MovieBookView(
      posterPath: "/bUrReoZFLGti6ehkBW0xw8f12MT.jpg",
      title: "The Dark Knight"
  )
}
