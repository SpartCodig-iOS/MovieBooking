//
//  SuperBaseManger.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation

import Supabase

public class SuperBaseManger {

  static let shared = SuperBaseManger()

  let client = SupabaseClient(
    supabaseURL: URL(string: "https://\(Bundle.main.object(forInfoDictionaryKey: "SuperBaseURL") as? String ?? "")")!,
      supabaseKey: "\(Bundle.main.object(forInfoDictionaryKey: "SuperBaseKey") as? String ?? "")",
    options: .init(
        auth: .init(
          redirectToURL: URL(string: "movieBooking://login-callback/")!,
          flowType: .pkce,
          autoRefreshToken: true
        )
      )
    )

}

