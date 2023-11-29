//
//  WeatherModel.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import Foundation



struct WeatherModel {
    private var dbManager : DbManager
    var latitude = 59.3293
    var longitude = 18.0686
    private var weatherData : [WeatherData] = []
    
    
    init(latitude: Double = 59.3293, longitude: Double = 18.0686) {
        self.latitude = latitude
        self.longitude = longitude
        self.dbManager = DbManager()
        getData()
        updateWeatherData()
    }
    
    func getWeatherData() -> WeatherData{
        return weatherData[0]
    }
    
    
    
   func getData() {
        let endpoint = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,weather_code")!
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: endpoint) { (data, response, error ) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    if let jsonData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                        dbManager.insertWeatherData(weatherData: jsonData)
                        print("jsonData")
                    } else {
                        print("Failed to decode JSON into WeatherData")
                    }
                }
            }
        }
        task.resume()
        
        session.finishTasksAndInvalidate()
    }
    
    mutating func updateWeatherData(){
        self.weatherData = dbManager.getWeatherData()
    }
         
}
