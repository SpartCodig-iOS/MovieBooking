//
//  StarRatingView.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import SwiftUI

struct DetailStarRatingView: View {
  private let rating: Double // 0.0 ~ 10.0 범위
  private let maxStars: Int = 5
  
  init(rating: Double) {
    self.rating = rating
  }

  private var normalizedRating: Double {
    // 10점 만점을 5점 만점으로 환산
    min(max(rating / 2.0, 0), Double(maxStars))
  }

  var body: some View {
    HStack {
      HStack(spacing: 2) {
        ForEach(0..<maxStars, id: \.self) { index in
          ZStack {
            // 배경 별 (회색)
            Image(systemName: "star.fill")
              .foregroundColor(.gray.opacity(0.3))
            
            // 채워진 별 (노란색)
            Image(systemName: "star.fill")
              .foregroundColor(.yellow)
              .mask(
                GeometryReader { geometry in
                  let fillWidth = calculateFillWidth(
                    for: index,
                    totalWidth: geometry.size.width
                  )
                  Rectangle()
                    .frame(width: fillWidth)
                }
              )
          }
        }
      }
      
      Text(String(format: "%.1f", normalizedRating))
        .foregroundColor(.primary)
        .font(.system(size: 16, weight: .light))
    }
  }

  private func calculateFillWidth(for index: Int, totalWidth: CGFloat) -> CGFloat {
    let starValue = Double(index)
    let nextStarValue = Double(index + 1)

    if normalizedRating >= nextStarValue {
      // 완전히 채워진 별
      return totalWidth
    } else if normalizedRating > starValue {
      // 부분적으로 채워진 별
      let fraction = normalizedRating - starValue
      return totalWidth * fraction
    } else {
      // 빈 별
      return 0
    }
  }
}

#Preview {
  VStack(spacing: 20) {
    DetailStarRatingView(rating: 8.7)

    DetailStarRatingView(rating: 7.5)

    DetailStarRatingView(rating: 9.2)

    DetailStarRatingView(rating: 5.0)

    DetailStarRatingView(rating: 10.0)
  }
  .padding()
}
