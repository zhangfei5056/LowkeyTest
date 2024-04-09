//
//  HTTPService.swift
//  LowkeyTest
//
//  Created by Yuan Cao on 2024/04/09.
//

import Foundation

protocol HTTPServiceProtocol {
    func getRequestAsync(url: String) async throws -> CuratedPhotos
}

struct NetworkConstant {
    static let apiKey = "k6ps79XLcN34S3CjNPXEmDztGOpjxKyNsQ6dHxa1lJgFC9YpN0rknaXj"
    static let per_page = 15
    static let url = "https://api.pexels.com/v1/curated/?page=1&per_page=\(NetworkConstant.per_page)"
}

class HTTPService: HTTPServiceProtocol {

    var urlSession: URLSession

    init(urlSession: URLSession? = nil) {
        if let urlSession = urlSession {
            self.urlSession = urlSession
        } else {
            let configuration = URLSessionConfiguration.default
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            self.urlSession = URLSession(configuration: configuration)
        }
    }

    enum NetworkError: Error {
        case invalidURL
        case invalidResponse
        case invalidJSON
    }

    func getRequestAsync(url: String) async throws -> CuratedPhotos {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.setValue(NetworkConstant.apiKey, forHTTPHeaderField: "Authorization")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            return try JSONDecoder().decode(CuratedPhotos.self, from: data)
        } catch {
            throw NetworkError.invalidJSON
        }
    }
}
