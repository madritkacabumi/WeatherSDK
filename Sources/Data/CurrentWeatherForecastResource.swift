//
//  CurrentWeatherResource.swift
//  WeatherSDK
//
//  Created by Madrit Kacabumi on 23.08.24.
//

import Foundation

struct CurrentWeatherForecastResource: APIResource {
    let httpMethod = HTTPMethod.get
    let requestURLString: String
    let parameters: [String : Any]?
    let headers: [String : String]? = nil

    init(city: String, apiConfig: APIConfig) {
        requestURLString = apiConfig.baseAPI + "/current"
        parameters = ["city": city, "key": apiConfig.key]
    }
}
