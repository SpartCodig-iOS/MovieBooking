//
//  BookingListView.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import SwiftUI
import ComposableArchitecture

@ViewAction(for: BookingListFeature.self)
struct BookingListView: View {
  @Perception.Bindable var store: StoreOf<BookingListFeature>
  
  var body: some View {
    WithPerceptionTracking {
      VStack {
        headerView
          .frame(maxWidth: .infinity, alignment: .leading)
        
        Group {
          if store.isLoading {
            ProgressView("예매 내역 불러오는 중...")
          } else if store.bookings.isEmpty {
            emptyView
          } else {
            bookingList
          }
        }
        .frame(maxHeight: .infinity)
      }
      .padding()
      .onAppear {
        send(.onAppear)
      }
    }
  }

  @ViewBuilder
  private var headerView: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("예매 내역")
        .font(.system(size: 20, weight: .semibold))
        .foregroundStyle(Color.primary)
      
      Text("내가 예매한 영화를 확인하세요")
        .font(.system(size: 16, weight: .regular))
        .foregroundStyle(Color.secondary)
    }
  }
  
  @ViewBuilder
  private var emptyView: some View {
    VStack(alignment: .center, spacing: 16) {
      Image(systemName: "ticket")
        .font(.system(size: 60))
        .foregroundColor(.gray)

      Text("예매 내역이 없습니다")
        .font(.headline)
        .foregroundColor(.gray)

      Text("영화를 예매하면 여기에 표시됩니다")
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
  }
  
  @ViewBuilder
  private var bookingList: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        ForEach(store.bookings) { booking in
          BookingCard(booking: booking) {
            send(.deleteBooking(id: booking.id))
          }
        }
      }
    }
  }
}

#Preview {
  BookingListView(
    store: Store(
      initialState: BookingListFeature.State(
        bookings: [
          BookingInfo(
            movieId: "1",
            movieTitle: "The Dark Knight",
            posterPath: "/bUrReoZFLGti6ehkBW0xw8f12MT.jpg",
            theaterId: 1,
            theaterName: "CGV 강남",
            showDate: Date().addingTimeInterval(86400 * 3),
            showTime: "14:30",
            numberOfPeople: 2,
            totalPrice: 26000
          ),
          BookingInfo(
            movieId: "2",
            movieTitle: "Inception",
            posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
            theaterId: 2,
            theaterName: "메가박스 코엑스",
            showDate: Date().addingTimeInterval(86400 * 5),
            showTime: "19:00",
            numberOfPeople: 1,
            totalPrice: 13000
          )
        ]
      )
    ) {
      BookingListFeature()
    }
  )
}
