//
//  PaymentInfoCard.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import SwiftUI

struct PaymentInfoCard: View {
  let posterPath: String
  let title: String
  let pricePerTicket: Int
  let numberOfPeople: Int
  let onPaymentTapped: () -> Void

  private var totalPrice: Int {
    pricePerTicket * numberOfPeople
  }

  var body: some View {
    VStack(spacing: 24) {
      VStack(spacing: 16) {
        // 헤더: 로고 + 결제 정보
        HStack {
          Image(systemName: "creditcard")
            .font(.system(size: 24))
            .foregroundColor(.basicPurple)
          
          Text("결제 정보")
            .font(.system(size: 18, weight: .light))
          
          Spacer()
        }
        
        // 이미지 + 타이틀
        HStack(alignment: .top, spacing: 16) {
          AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
            case .failure:
              Color.gray
            case .empty:
              ProgressView()
            @unknown default:
              EmptyView()
            }
          }
          .frame(width: 70, height: 70)
          .clipShape(RoundedRectangle(cornerRadius: 16))
        
          Text(title)
            .font(.system(size: 18, weight: .light))
            .lineLimit(2)
          
          Spacer()
        }
        
        Divider()
          .overlay(Color.white)

        HStack {
          Text("일반 관람권 (\(numberOfPeople)매)")

          Spacer()

          Text("\(pricePerTicket.formatted()) 원")
        }
        .font(.system(size: 16, weight: .light))
        .foregroundColor(.secondary)

        Divider()
          .overlay(Color.white)
        
        // 총 결제금액
        HStack {
          Text("총 결제금액")
            .font(.system(size: 18, weight: .regular))
          
          Spacer()
          
          Text("\(totalPrice.formatted()) 원")
            .font(.system(size: 24, weight: .regular))
            .foregroundColor(.basicPurple)
        }
      }
      .padding(20)
      .background(
        LinearGradient(
          gradient: Gradient(colors: [
            Color.basicPurple.opacity(0.1),
            Color.basicPurple.opacity(0.2),
            Color.basicPurple.opacity(0.25),
            Color.basicPurple.opacity(0.2),
            Color.basicPurple.opacity(0.1)
          ]),
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .overlay(
        RoundedRectangle(cornerRadius: 16)
          .stroke(Color.basicPurple.opacity(0.15), lineWidth: 0.5)
      )
      .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 3)

      // 결제하기 버튼
      Button(action: onPaymentTapped) {
        Text("결제하기")
          .frame(maxWidth: .infinity)
          .font(.system(size: 18, weight: .bold))
          .foregroundStyle(Color.white)
          .padding(.vertical, 16)
          .background(Color.basicPurple)
          .clipShape(Capsule())
      }
    }
  }
}

#Preview {
  PaymentInfoCard(
    posterPath: "/bUrReoZFLGti6ehkBW0xw8f12MT.jpg",
    title: "The Dark Knight",
    pricePerTicket: 13000,
    numberOfPeople: 2,
    onPaymentTapped: {
      print("결제하기 버튼 눌림")
    }
  )
  .padding()
}
