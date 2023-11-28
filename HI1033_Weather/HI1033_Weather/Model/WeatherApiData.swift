//
//  WeatherApiData.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import Foundation
import SQLite3


struct WeatherApiData{
    
    private var theModel : WeatherModel
    var db : OpaquePointer?
    var path : String = "myDb.sqlite"
    private var dbManager : DbManager
    
    init(){
        theModel = WeatherModel()
        dbManager = DbManager();
    }
    
    func getData() {
        let endpoint = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(theModel.latitude)&longitude=\(theModel.longitude)&hourly=temperature_2m,weather_code")!
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: endpoint) { (data, response, error ) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let data = data {
                if let dataString = String(data: data, encoding: .utf8) {
                    if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                        dbManager.insertWeatherData(weatherData: weatherData)
                        //print("Data received: \(weatherData)")
                        let testing = dbManager.getWeatherData()
                        /*
                        for t in testing {
                            printWeatherData(t)
                        }
                         */
                        print(testing.count)
                        
                    } else {
                        print("Failed to decode JSON into WeatherData")
                    }
                }
            }
        }
        task.resume()
        
        session.finishTasksAndInvalidate()
    }
    
    func printWeatherData(_ weatherData: WeatherData) {
        print("Latitude: \(weatherData.latitude)")
        print("Longitude: \(weatherData.longitude)")
        print("Generation Time (ms): \(weatherData.generationtimeMS)")
        print("UTC Offset Seconds: \(weatherData.utcOffsetSeconds)")
        print("Timezone: \(weatherData.timezone)")
        print("Timezone Abbreviation: \(weatherData.timezoneAbbreviation)")
        print("Elevation: \(weatherData.elevation)")

        // Print Hourly data
        print("\nHourly Data:")
        for (index, time) in weatherData.hourly.time.enumerated() {
            print("  Time \(index + 1): \(time)")
            
            // Check bounds before accessing elements in temperature2M and weatherCode arrays
            if index < weatherData.hourly.temperature2M.count {
                print("  Temperature 2M: \(weatherData.hourly.temperature2M[index])")
            }
            
            if index < weatherData.hourly.weatherCode.count {
                print("  Weather Code: \(weatherData.hourly.weatherCode[index])")
            }

            print("----")
        }
    }
}
