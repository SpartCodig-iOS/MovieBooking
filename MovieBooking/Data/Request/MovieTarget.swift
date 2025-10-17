//
//  MovieTarget.swift
//  MovieBooking
//
//  Created by 김민희 on 10/17/25.
//

import Foundation

enum MovieTarget {
    case movieDetail(id: String)
    case movieList(category: MovieCategory, page: Int = 1)
}
