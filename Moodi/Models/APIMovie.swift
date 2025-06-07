//
//  APIMovie.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import Foundation

struct APIMovie: Codable {
    let id: Int
    let title: String
    let overview: String
    let poster_path: String?
}
