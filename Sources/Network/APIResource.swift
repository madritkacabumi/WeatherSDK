//
//  APIResource.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import Foundation

protocol APIResource {
    var httpMethod: HTTPMethod { get }
    var requestURLString: String { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
