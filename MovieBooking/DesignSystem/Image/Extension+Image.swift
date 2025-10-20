//
//  Extension+Image.swift
//  MovieBooking
//
//  Created by Wonji Suh  on 10/14/25.
//

import Foundation
import SwiftUI

public extension UIImage {
  convenience init?(_ asset: ImageAsset) {
    self.init(named: asset.rawValue, in: Bundle.main, with: nil)
  }

  convenience init?(assetName: String) {
    self.init(named: assetName, in: Bundle.main, with: nil)
  }
}

public extension Image {
  init(asset: ImageAsset) {
    if let uiImage = UIImage(asset) {
      self.init(uiImage: uiImage)
    } else {
      self = Image(systemName: "questionmark")
    }
  }

  init(assetName: String) {
    if let uiImage = UIImage(assetName: assetName) {
      self.init(uiImage: uiImage)
    } else {
      self = Image(systemName: "questionmark")
    }
  }
}


