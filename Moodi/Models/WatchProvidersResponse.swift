//
//  WatchProvidersResponse.swift
//  Moodi
//
//  Created by Maria Amzil on 8/6/25.
//

import Foundation

struct WatchProvidersResponse: Codable {
    let results: [String: ProvidersByCountry]
}
