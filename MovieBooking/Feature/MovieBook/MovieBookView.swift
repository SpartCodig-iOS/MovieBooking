//
//  MovieBookView.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: MovieBookFeature.self)
struct MovieBookView: View {
  @Perception.Bindable var store: StoreOf<MovieBookFeature>
  
  var body: some View {
    WithPerceptionTracking {
      ScrollView {
        VStack(spacing: 24) {
          // 극장/시간/인원 선택 카드
          BookingOptionsCard(
            theaters: store.theaters,
            times: store.times,
            selectedTheater: $store.selectedTheater,
            selectedTime: $store.selectedTime,
            numberOfPeople: $store.numberOfPeople
          )
          // 결제 정보 카드
          PaymentInfoCard(
            posterPath: store.posterPath,
            title: store.title,
            pricePerTicket: store.pricePerTicket,
            numberOfPeople: store.numberOfPeople,
            onPaymentTapped: { send(.onTapBookButton) }
          )
          .disabled(store.isBookingInProgress)
          .opacity(store.isBookingInProgress ? 0.6 : 1.0)
        }
        .padding(24)
      }
      .onAppear {
        send(.onAppear)
      }
      .alert($store.scope(state: \.alert, action: \.alert))
      .overlay {
        if store.isBookingInProgress {
          ProgressView("예매 중...")
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
        }
      }
    }
  }
}

#Preview {
  MovieBookView(
    store: Store(
      initialState: MovieBookFeature.State(
        movieId: "12345",
        posterPath: "/bUrReoZFLGti6ehkBW0xw8f12MT.jpg",
        title: "The Dark Knight"
      )
    ) {
      MovieBookFeature()
    }
    )
}
