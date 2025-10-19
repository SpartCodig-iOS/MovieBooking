//
//  BookingCard.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/19/25.
//

import SwiftUI

struct BookingCard: View {
  let booking: BookingInfo
  let onDelete: () -> Void

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(alignment: .center, spacing: 16) {
        // 포스터 이미지
        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(booking.posterPath)")) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        } placeholder: {
          Rectangle()
            .fill(Color.gray.opacity(0.3))
        }
        .frame(width: 80, height: 120)
        .cornerRadius(8)

        VStack(alignment: .leading, spacing: 8) {
          HStack {
            Text(booking.movieTitle)
              .font(.headline)
              .lineLimit(2)
            
            Spacer()
            
            Button(role: .destructive) {
              onDelete()
            } label: {
              Image(systemName: "trash")
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .foregroundColor(.red)
                .cornerRadius(8)
            }
          }

          VStack(alignment: .leading, spacing: 4) {
            HStack {
              Image(systemName: "building.2")
                .font(.caption)
              Text(booking.theaterName)
                .font(.subheadline)
            }

            HStack {
              Image(systemName: "calendar")
                .font(.caption)
              Text(booking.displayShowDate)
                .font(.subheadline)
            }

            HStack {
              Image(systemName: "clock")
                .font(.caption)
              Text(booking.showTime)
                .font(.subheadline)
            }

            HStack {
              Image(systemName: "person.2")
                .font(.caption)
              Text("\(booking.numberOfPeople)명")
                .font(.subheadline)
            }
          }
          .foregroundColor(.secondary)

          Divider()
          
          HStack {
            Text("총 결제")
              .font(.subheadline)
              .foregroundColor(.secondary)
            
            Spacer()
            
            Text("\(booking.totalPrice.formatted())원")
              .font(.system(size: 18, weight: .light))
              .foregroundColor(.basicPurple)
          }
        }
      }
    }
    .padding()
    .background(Color.white)
    .cornerRadius(12)
    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
  }
}

#Preview {
  BookingCard(booking: BookingInfo(
    movieId: "2",
    movieTitle: "Inception",
    posterPath: "/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg",
    theaterId: 2,
    theaterName: "메가박스 코엑스",
    showDate: Date().addingTimeInterval(86400 * 5),
    showTime: "19:00",
    numberOfPeople: 1,
    totalPrice: 13000
  ), onDelete: { })
}
