//
//  WeatherDataServices.swift
//  Clima
//
//  Created by Carlos Rios on 1/07/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit

protocol WeatherDataServicesDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherDataServices {
    
    var delegate: WeatherDataServicesDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=8c6fcabb715dc2ca3df78d3a422248a2&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
     
    func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
            }
            
            guard let dataResponse = data else {
                return
            }
            
            guard let weather = self.parseJSON(weatherData: dataResponse) else {
                return
            }
            
            self.delegate?.didUpdateWeather(weather: weather)
                
        }
        
        task.resume()
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodeData.weather[0].id
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            return WeatherModel(conditionId: id, cityName: name, temperature: temp)
            
        } catch {
            print(error)
            return nil
        }
    }
}
