//
//  MovieDetailCardView.swift
//  MovieBooking
//
//  Created by 홍석현 on 10/16/25.
//

import SwiftUI

struct MovieDetailCardView: View {
  private let model: MovieDetail
  
  init(model: MovieDetail) {
    self.model = model
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      GenreLabel(genre: Genre(id: 0, name: "Drama"))
      
      VStack(alignment: .leading, spacing: 12) {
        titleView
        
        StarRatingView(rating: model.rating)
        
        HStack(spacing: 24) {
          ReleaseDateView(date: model.releaseDate)
          
          RunningTimeView(model.runningTime)
        }
      }
      
      VStack(alignment: .leading, spacing: 12) {
        Text("줄거리")
          .font(.system(size: 18, weight: .semibold))
          .foregroundStyle(Color.primary)
        Text(model.summary)
          .font(.system(size: 16, weight: .regular))
          .lineSpacing(3)
          .foregroundStyle(Color(hex: "757575"))
      }
      
      Button {
        print("예매하기 버튼 눌림")
      } label: {
        Text("예매하기")
          .frame(maxWidth: .infinity)
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(Color.white)
          .padding(.vertical, 16)
          .background(Color.basicPurple)
          .clipShape(Capsule())
          .shadow(color: .black.opacity(0.2), radius: 5, y: 5)
      }

    }
    .padding(24)
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .shadow(color: .black.opacity(0.2), radius: 10, y: 10)
  }
}

extension MovieDetailCardView {
  // 영화 제목
  var titleView: some View {
    Text(model.title)
      .font(.system(size: 36, weight: .light))
      .frame(maxWidth: 200, alignment: .leading)
      .lineSpacing(0)
  }
  
  // 상영 날짜
  struct ReleaseDateView: View {
    private let date: Date?

    init(date: Date?) {
      self.date = date
    }
    
    private var displayText: String {
      guard let date = date else { return "개봉일 미정" }
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy. MM. dd."
      return formatter.string(from: date)
    }

    var body: some View {
      HStack {
        Image(systemName: "calendar")
          .foregroundStyle(Color.secondary)

        Text(displayText)
      }
      .font(.system(size: 16))
      .foregroundStyle(Color.secondary)
    }
  }
  
  // 러닝 타임
  struct RunningTimeView: View {
    private let runningSecond: Int
    
    private var displayText: String {
      return "\(runningSecond / 60)분"
    }
    
    init(_ runningSecond: Int) {
      self.runningSecond = runningSecond
    }
    
    var body: some View {
      HStack {
        Image(systemName: "clock")
          .foregroundStyle(Color.secondary)

        Text(displayText)
      }
      .font(.system(size: 16))
      .foregroundStyle(Color.secondary)
    }
  }
}

#Preview {
  MovieDetailCardView(model: .mockData)
    .padding()
}
