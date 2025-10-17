//
//  DIRegistry.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import WeaveDI

/// 모든 의존성을 자동으로 등록하는 레지스트리
extension WeaveDI.Container {
  private static let helper = RegisterModule()

  ///  Repository 등록
  static func registerRepositories() async {
    let repositories: [Module] = [
      helper.authRepositoryModule(),
      helper.oAuthRepositoryModule()
    ]

    await repositories.asyncForEach { module in
      await module.register()
    }
  }

  ///  UseCase 등록
  static func registerUseCases() async {

    let useCases: [Module] = [
      helper.authUseCaseModule(),
      helper.oAuthUseCaseModule()
    ]

    await useCases.asyncForEach { module in
      await module.register()
    }
  }
}
