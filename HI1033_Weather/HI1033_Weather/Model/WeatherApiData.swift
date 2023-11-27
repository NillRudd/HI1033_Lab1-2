//
//  WeatherApiData.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import Foundation


struct WeatherApiData{
    
    private var theModel : WeatherModel

    init(){
        theModel = WeatherModel()
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
                    print("Data recieved: \(dataString)")
                }
            }
        }
        task.resume()
        
        session.finishTasksAndInvalidate()
    }
    
    
}
