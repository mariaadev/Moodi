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
    let synospsis: String
    let imageName: String
    
    static let example = Movie(id: UUID(), title: "Inception", synospsis: "A mind-bending thriller by Christopher Nolan.", imageName: "inception")
}

