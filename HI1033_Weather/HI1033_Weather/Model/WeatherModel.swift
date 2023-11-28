//
//  WeatherModel.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import Foundation

struct WeatherModel {
    
    var latitude = 59.3293
    var longitude = 18.0686
    
    
    
    init(latitude: Double = 59.3293, longitude: Double = 18.0686) {
        self.latitude = latitude
        self.longitude = longitude
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
                    print("Data recieved: \(dataString)")
                }
            }
        }
        task.resume()
        
        session.finishTasksAndInvalidate()
    }
}
