//
//  MovieListFeature.swift
//  MovieBooking
//
//  Created by 김민희 on 10/15/25.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MovieListFeature {
  @Dependency(\.movieRepository) var movieRepository

  @ObservableState
  public struct State: Equatable {
    var nowPlayingMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var isLoading = false
    @Presents var alert: AlertState<Action.Alert>?
  }

  public enum Action {
    case onAppear
    case fetchMovie
    case fetchNowPlayingResponse(Result<[Movie], Error>)
    case fetchUpcomingResponse(Result<[Movie], Error>)
    case fetchPopularResponse(Result<[Movie], Error>)
    case selectMovie(id: Int)
    case alert(PresentationAction<Alert>)

    public enum Alert: Equatable {
      case retry
    }
  }


  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.fetchMovie)

      case .fetchMovie:
        state.isLoading = true
        state.alert = nil
        return .run { send in
          await withThrowingTaskGroup(of: Void.self) { group in
            // Now Playing
            group.addTask {
              do {
                let movies = try await movieRepository.fetchNowPlayingMovies()
                await send(.fetchNowPlayingResponse(.success(movies)))
              } catch {
                await send(.fetchNowPlayingResponse(.failure(error)))
              }
            }
            // Upcoming
            group.addTask {
              do {
                let movies = try await movieRepository.fetchUpcomingMovies()
                await send(.fetchUpcomingResponse(.success(movies)))
              } catch {
                await send(.fetchUpcomingResponse(.failure(error)))
              }
            }
            // Popular
            group.addTask {
              do {
                let movies = try await movieRepository.fetchPopularMovies()
                await send(.fetchPopularResponse(.success(movies)))
              } catch {
                await send(.fetchPopularResponse(.failure(error)))
              }
            }

            do {
              try await group.waitForAll()
            } catch {
              print("⚠️ 일부 영화 목록 로드 실패: \(error)")
            }
          }
        }

      case let .fetchNowPlayingResponse(.success(movies)):
        state.nowPlayingMovies = movies
        state.isLoading = false
        return .none

      case let .fetchUpcomingResponse(.success(movies)):
        state.upcomingMovies = movies
        state.isLoading = false
        return .none

      case let .fetchPopularResponse(.success(movies)):
        state.popularMovies = movies
        state.isLoading = false
        return .none

      case let .fetchNowPlayingResponse(.failure(error)),
        let .fetchUpcomingResponse(.failure(error)),
        let .fetchPopularResponse(.failure(error)):
        let networkError = (error as? NetworkError) ?? .unknown(error)
        let message = networkError.errorDescription ?? "잠시 후 다시 시도해 주세요"
        print("❌ 영화 가져오기 실패: \(networkError)")
        state.isLoading = false
        state.alert = AlertState {
          TextState("영화 목록을 불러오지 못했습니다")
        } actions: {
          ButtonState(action: .send(.retry)) {
            TextState("재시도")
          }
          ButtonState(role: .cancel) {
            TextState("확인")
          }
        } message: {
          TextState(message)
        }
        return .none

      case .selectMovie:
        return .none

      case .alert(.presented(.retry)):
        return .send(.fetchMovie)

      case .alert:
        return .none
      }
    }
  }
}

extension MovieListFeature.State: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(nowPlayingMovies)
    hasher.combine(upcomingMovies)
    hasher.combine(popularMovies)
    hasher.combine(isLoading)
    // @Presents var alert는 Hashable이 아니므로 제외
  }
}
