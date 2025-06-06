//
//  Mood.swift
//  Moodi
//
//  Created by Maria Amzil on 6/6/25.
//

import Foundation

enum Mood: String, CaseIterable, Identifiable {
    case happy, sad, romantic, adventurous, relaxed, intense

    var id: String { self.rawValue }

    var genres: [String] {
        switch self {
            case .happy:
                return ["Comedy", "Family"]
            case .sad:
                return ["Drama", "Biography"]
            case .romantic:
                return ["Romance"]
            case .adventurous:
                return ["Adventure", "Action"]
            case .relaxed:
                return ["Animation", "Fantasy"]
            case .intense:
                return ["Thriller", "Horror"]
        }
    }
}
