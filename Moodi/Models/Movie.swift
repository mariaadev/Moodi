//
//  Movie.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import Foundation

struct Movie : Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let synopsis: String
    let posterURL: URL?
}

