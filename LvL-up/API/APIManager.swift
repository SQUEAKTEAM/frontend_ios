//
//  APIManager.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import Foundation

final class APIManager {
    static let baseURL = "https://localhost:8000/"
    static let shared = APIManager()
    private init() {}
    
    func fetch<T: Decodable>(_ endpoint: String) async throws -> T {
        guard let url = URL(string: APIManager.baseURL + endpoint) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
