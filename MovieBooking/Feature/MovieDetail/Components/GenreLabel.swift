//
//  GenreLabel.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/17/25.
//

import SwiftUI

struct GenreLabel: View {
  private let genre: Genre

  init(genre: Genre) {
    self.genre = genre
  }

  private var genreColor: Color {
    switch genre.id {
    case "28": return Color(red: 0.95, green: 0.26, blue: 0.21)    // 액션 - Vibrant Red
    case "12": return Color(red: 0.13, green: 0.59, blue: 0.95)    // 모험 - Sky Blue
    case "16": return Color(red: 1.0, green: 0.49, blue: 0.78)     // 애니메이션 - Bright Pink
    case "35": return Color(red: 1.0, green: 0.76, blue: 0.03)     // 코미디 - Golden Yellow
    case "80": return Color(red: 0.29, green: 0.29, blue: 0.29)    // 범죄 - Charcoal
    case "99": return Color(red: 0.6, green: 0.4, blue: 0.2)       // 다큐멘터리 - Brown
    case "18": return Color(red: 0.61, green: 0.35, blue: 0.71)    // 드라마 - Medium Purple
    case "10751": return Color(red: 0.3, green: 0.69, blue: 0.31)  // 가족 - Fresh Green
    case "14": return Color(red: 0.82, green: 0.41, blue: 0.88)    // 판타지 - Orchid
    case "36": return Color(red: 0.71, green: 0.55, blue: 0.39)    // 역사 - Antique Gold
    case "27": return Color(red: 0.18, green: 0.05, blue: 0.21)    // 공포 - Deep Purple
    case "10402": return Color(red: 0.91, green: 0.12, blue: 0.39) // 음악 - Deep Pink
    case "9648": return Color(red: 0.4, green: 0.23, blue: 0.72)   // 미스터리 - Royal Purple
    case "10749": return Color(red: 1.0, green: 0.31, blue: 0.48)  // 로맨스 - Rose
    case "878": return Color(red: 0.0, green: 0.74, blue: 0.83)    // SF - Cyan
    case "10770": return Color(red: 0.61, green: 0.64, blue: 0.69) // TV 영화 - Slate Gray
    case "53": return Color(red: 0.9, green: 0.38, blue: 0.18)     // 스릴러 - Burnt Orange
    case "10752": return Color(red: 0.47, green: 0.53, blue: 0.27) // 전쟁 - Military Green
    case "37": return Color(red: 0.82, green: 0.61, blue: 0.36)    // 서부 - Desert Sand
    default: return Color.basicPurple                               // 기본값
    }
  }

  var body: some View {
    Text(genre.name)
      .font(.caption)
      .foregroundColor(.white)
      .padding(.vertical, 4)
      .padding(.horizontal, 8)
      .background(genreColor)
      .clipShape(Capsule())
      .overlay(
        Capsule()
          .stroke(genreColor.opacity(0.5), lineWidth: 1)
      )
  }
}

#Preview {
  GenreLabel(genre: Genre(id: "0", name: "Drama"))
}
