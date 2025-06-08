//
//  MovieDetail.swift
//  Moodi
//
//  Created by Maria Amzil on 8/6/25.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let runtime: Int?
    let genres: [Genre]
    let release_date: String?
}
