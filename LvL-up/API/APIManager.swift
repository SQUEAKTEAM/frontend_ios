//
//  APIManager.swift
//  LvL-up
//
//  Created by MyBook on 02.05.2025.
//

import Foundation

final class APIManager {
    static let baseURL = "http://192.168.0.101:5000/"
    static let shared = APIManager()
    private init() {}
    
    var accessToken: String?
    var refreshToken: String?
    
    // MARK: - GET Request
    func fetch<T: Decodable>(_ endpoint: String, retry: Bool = true) async throws -> T {
        guard let url = URL(string: APIManager.baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 401 && retry {
            try await refresh()
            return try await fetch(endpoint, retry: false)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - POST Request
    func post<T: Decodable, U: Encodable>(_ endpoint: String, body: U, retry: Bool = true) async throws -> T {
        guard let url = URL(string: APIManager.baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoder = JSONEncoder.iso8601WithMilliseconds
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 401 && retry {
            try await refresh()
            return try await post(endpoint, body: body, retry: false)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        if data.isEmpty {
            return try JSONDecoder().decode(T.self, from: "{}".data(using: .utf8)!)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func postText<U: Encodable>(_ endpoint: String, body: U, retry: Bool = true) async throws -> String {
        guard let url = URL(string: APIManager.baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 401 && retry {
            try await refresh()
            return try await postText(endpoint, body: body, retry: false)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return responseString
    }
    
    // MARK: - PUT Request
    func put<T: Decodable, U: Encodable>(_ endpoint: String, body: U, retry: Bool = true) async throws -> T {
        guard let url = URL(string: APIManager.baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoder = JSONEncoder.iso8601WithMilliseconds
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 401 && retry {
            try await refresh()
            return try await put(endpoint, body: body, retry: false)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // MARK: - DELETE Request
    func delete(_ endpoint: String, retry: Bool = true) async throws {
        guard let url = URL(string: APIManager.baseURL + endpoint) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 401 && retry {
            try await refresh()
            return try await delete(endpoint, retry: false)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    
    func refresh() async throws {
        guard let refreshToken = refreshToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let tokens: TokenDto? = try await post("api/auth/refresh", body: TokenDto(accessToken: accessToken ?? "", refreshToken: refreshToken), retry: false)
        
        guard let newAccessToken = tokens?.accessToken, let newRefreshToken = tokens?.refreshToken else {
            throw URLError(.userAuthenticationRequired)
        }
        
        self.accessToken = newAccessToken
        self.refreshToken = newRefreshToken
    }
}

struct EmptyResponse: Decodable {}

struct TokenDto: Codable {
    let accessToken: String
    let refreshToken: String
}
