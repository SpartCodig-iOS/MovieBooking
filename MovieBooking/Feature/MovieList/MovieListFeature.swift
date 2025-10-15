//
//  MovieListFeature.swift
//  MovieBooking
//
//  Created by 김민희 on 10/15/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MovieListFeature {
  @Dependency(\.movieRepository) var movieRepository

  @ObservableState
  public struct State {
    var nowPlayingMovies: [Movie] = []
    var upcomingMovies: [Movie] = []
    var popularMovies: [Movie] = []
    var isLoading = false
  }

  enum Action {
    case onAppear
    case fetchMovie
    case fetchNowPlayingResponse(Result<[Movie], Error>)
    case fetchUpcomingResponse(Result<[Movie], Error>)
    case fetchPopularResponse(Result<[Movie], Error>)
    case selectMovie
  }

  var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.fetchMovie)

      case .fetchMovie:
        state.isLoading = true
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
        print("❌ 영화 가져오기 실패: \(error)")
        state.isLoading = false
        return .none

      case .selectMovie:
        //TODO: 상세로 넘어감
        return .none
      }
    }
  }
}
