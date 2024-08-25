//
//  APIRequest.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import Foundation

struct APIRequest {
    let resource: APIResource

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: resource.requestURLString)!)
        urlRequest.httpMethod = resource.httpMethod.rawValue
        resource.headers?.forEach { (field, value) in
            urlRequest.setValue(value, forHTTPHeaderField: field)
        }
        if let parameters = resource.parameters {
            if resource.httpMethod == .post {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } else {
                let url = URL(string: resource.requestURLString)!
                var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                urlRequest.url = components?.url
            }
        }
        return urlRequest
    }
}
