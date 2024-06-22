//
//  Weather.swift
//  WeatherApp
//
//  Created by 이찬호 on 6/22/24.
//

import Foundation

struct WeatherResult: Decodable {
    let weather: [Weather]
    let main: WeatherMain
    let wind: Wind
    let rain: Rain?
    let snow: Snow?
    let name: String
    
    
    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }
    
    struct WeatherMain: Decodable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int
        
        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
        
    }
    
    struct Wind: Decodable {
        let speed: Double
        let deg: Int
    }
    
    struct Rain: Decodable {
        let precipitation: Double
        
        enum CodingKeys: String, CodingKey {
            case precipitation = "1h"
        }
    }
    
    struct Snow: Decodable {
        let precipitation: Double
        
        enum CodingKeys: String, CodingKey {
            case precipitation = "1h"
        }
    }
}
