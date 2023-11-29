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
    var locationString = "Stockholm"
    var geoData : [GeoData] = []
    
    init(latitude: Double = 59.3293, longitude: Double = 18.0686) {
        self.latitude = latitude
        self.longitude = longitude
        self.dbManager = DbManager()
        //getData()
        //updateWeatherData()
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
    

    
    
    func getGeoData() -> [GeoData]{
        let endpoint = URL(string: "https://www.smhi.se/wpt-a/backend_solr/autocomplete/search/\(locationString)")!
        var geoData : [GeoData] = []
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: endpoint) { (data, response, error ) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    do {
                        geoData = try JSONDecoder().decode([GeoData].self, from: data)
                    } catch {
                        print("Failed to decode JSON into GeoData. Error: \(error)")
                    }
                }
            }
            
        }
        task.resume()
        session.finishTasksAndInvalidate()
        return geoData
    }
    
    
    
    func iconFromCode(code: Int) -> String {
        var icon: String = ""
        switch code {
                    case 0:
                        icon = "☀️" // Clear sky
                    case 1, 2, 3:
                        icon = "🌤" // Mainly clear, partly cloudy, and overcast
                    case 45, 48:
                        icon = "☁️" // Fog and depositing rime fog
                    case 51, 53, 55:
                        icon = "🌧" // Drizzle: Light, moderate, and dense intensity
                    case 56, 57:
                        icon = "🌧❄️" // Freezing Drizzle: Light and dense intensity
                    case 61, 63, 65:
                        icon = "🌧" // Rain: Slight, moderate and heavy intensity
                    case 66, 67:
                        icon = "🌧❄️" // Freezing Rain: Light and heavy intensity
                    case 71, 73, 75:
                        icon = "❄️" // Snow fall: Slight, moderate, and heavy intensity
                    case 77:
                        icon = "❄️" // Snow grains
                    case 80, 81, 82:
                        icon = "🌧" // Rain showers: Slight, moderate, and violent
                    case 85, 86:
                        icon = "❄️" // Snow showers slight and heavy
                    case 95:
                        icon = "⛈️" // Thunderstorm: Slight or moderate
                    case 96, 99:
                        icon = "⛈️❄️" // Thunderstorm with slight and heavy hail
                    default:
                        icon = "❓" // Unknown weather code
                    }
        return icon
       
       
    }
    
    mutating func updateWeatherData(){
        self.weatherData = dbManager.getWeatherData()
    }
    
}
