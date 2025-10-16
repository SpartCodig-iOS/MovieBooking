//
//  SplashView.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import SwiftUI
import ComposableArchitecture
import Supabase

let supabase = SuperBaseManger.shared.client
@ViewAction(for: SplashReducer.self)
public struct SplashView: View {
  @Perception.Bindable public var store: StoreOf<SplashReducer>

  public  var body: some View {
    WithPerceptionTracking {
      ZStack {
        LinearGradient(
          gradient: Gradient(colors: [
            .white,
            .white,
            .basicPurple.opacity(0.05)
          ]),
          startPoint: .top,
          endPoint: .bottom
        )
        .ignoresSafeArea()

        VStack(spacing: 24) {

          splashLogo()

          titleView()
        }
        .scaleEffect(store.fadeOut ? 0.95 : 1.0)
        .opacity(store.fadeOut ? 0.0 : 1.0)
        .animation(.easeInOut(duration: 1), value: store.fadeOut)
        .onAppear {
          send(.onAppear)

          Task {
            await runAuthCheck()
          }

        }
      }
    }
  }
}

@MainActor
func runAuthCheck() async {
    if let user = try? await checkSession() {
        let uuid = UUID(uuidString: user.id)!
        let exists = try? await checkUserExists(userId: uuid)
        print(exists == true ? "✅ 메인으로 이동" : "⚠️ 프로필 등록 필요")
    } else {
        print("❌ 로그인 안됨 → 로그인 화면 이동")
    }
}

extension SplashView {

  @ViewBuilder
  fileprivate func splashLogo() -> some View {
    ZStack {
      Circle()
        .fill(.basicPurple.opacity(0.4))
        .blur(radius: 24)
        .scaleEffect(store.pulse ? 1.08 : 0.95)
        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: store.pulse)

      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .fill(
          LinearGradient(
            colors: [
              .basicPurple,
              Color.purple
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 10)
        .frame(width: 120, height: 120)
        .overlay(
          Image(systemName: "film.fill")
            .font(.pretendardFont(family: .medium, size: 48))
            .foregroundColor(.white)
        )
    }
  }

  @ViewBuilder
  fileprivate func titleView() -> some View {
    VStack(spacing: 6) {
      Text("TicketSwift")
        .font(.pretendardFont(family: .semiBold, size: 32))
        .foregroundColor(.primary)

      Text("나만의 영화관, 지금 시작합니다 🎬")
        .font(.pretendardFont(family: .medium, size: 16))
        .foregroundColor(.secondary)
    }
  }
}


#Preview {
  SplashView(store: .init(initialState: SplashReducer.State(), reducer: {
    SplashReducer()
  }))
}



// MARK: - 로그인 세션 확인
func checkSession() async throws -> UserEntity? {
    if let session = supabase.auth.currentSession {
      return session.toDomain()
    }

    do {
        let session = try await supabase.auth.session
        return session.toDomain()
    } catch {
        print("세션 없음 또는 만료:", error)
        return nil
    }
}

    // MARK: - DB에서 UUID 존재 여부 확인
    func checkUserExists(userId: UUID) async throws -> Bool {
        let response = try await supabase
            .from("profiles")           // ✅ 여러분의 사용자 테이블 이름
            .select("id")
            .eq("id", value: userId)
            .limit(1)
            .execute()

        return !response.data.isEmpty
    }

private func isTokenExpiringSoon(_ session: Session, threshold: TimeInterval = 60) -> Bool {
    // expiresAt이 Double이라면 if let 필요 없음
    let expireDate = Date(timeIntervalSince1970: session.expiresAt)
    return expireDate.timeIntervalSinceNow <= threshold
}
