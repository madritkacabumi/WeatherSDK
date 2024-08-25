//
//  NetworkService.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import Foundation
import UIKit

protocol NetworkServiceType {
    func request<T: Decodable>(resource: APIResource, for type: T.Type) async throws -> T
}

enum NetworkError: Error {
    case invalidKey(_ message: String)
    case invalidResponse
    case decodingFailed
    case generic
}

private struct ErrorResponse: Decodable {
    let error: String
}

struct NetworkService: NetworkServiceType {
    // MARK: - Properties -

    let session: URLSession

    // MARK: - Initialization -

    public init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Request Method -

    func request<T: Decodable>(resource: APIResource, for type: T.Type) async throws -> T {
        let urlRequest = try APIRequest(resource: resource).asURLRequest()

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw filterErrorAndThrowCorrectNetworkServiceError(response: httpResponse, data: data)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    private func filterErrorAndThrowCorrectNetworkServiceError(response: HTTPURLResponse, data: Data) -> NetworkError {
        guard let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
            return .generic
        }
        if response.statusCode == 403 {
            return .invalidKey(errorResponse.error)
        }
        return .generic
    }
}
