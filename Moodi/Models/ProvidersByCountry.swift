//
//  ProvidersByCountry.swift
//  Moodi
//
//  Created by Maria Amzil on 8/6/25.
//

import Foundation

struct ProvidersByCountry: Codable {
    let flatrate: [Provider]?
    let rent: [Provider]?
    let buy: [Provider]?
}
