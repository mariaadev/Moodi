//
//  MovieResponse.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import Foundation

struct MovieResponse: Codable {
    let results: [APIMovie]
    let page: Int
    let total_pages: Int
    let total_results: Int
}
