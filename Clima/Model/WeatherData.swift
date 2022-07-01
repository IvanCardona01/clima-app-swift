//
//  WeatherData.swift
//  Clima
//
//  Created by Carlos Rios on 1/07/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let weather: [Weather]
    let main: Main
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}
