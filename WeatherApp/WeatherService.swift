//
//  WeatherService.swift
//  WeatherApp
//
//  Created by 이찬호 on 6/22/24.
//

import Foundation
import Alamofire

class WeatherService {
    static let shared = WeatherService()
    
    private init() {}
    
    func callRequest(lat: String, lon: String, completionHandler: @escaping ((WeatherResult) -> Void)) {
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let params: Parameters = [
            "lat": lat,
            "lon": lon,
            "appid": APIKey.openWeatherAPIKey,
            "units": "metric",
            "lang": "kr"
        ]
        AF.request(url, parameters: params)
            .responseDecodable(of: WeatherResult.self) { response in
                switch response.result {
                case .success(let v):
                    completionHandler(v)
                case .failure(let e):
                    print(e)
                }
            }
    }
}
