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
                        //print("Data received: \(dataString)")
                        print(dbManager.getWeatherData())
                    } else {
                        print("Failed to decode JSON into WeatherData")
                    }
                }
            }
        }
        task.resume()
        
        session.finishTasksAndInvalidate()
    }
    
    func storeDataInDb() {
        
        
    }
    
    func getDataFromDb() {
        
    }
    
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("There is error in creating db")
            return nil
        }else {
            print("Database has been created with path\(path)")
            return db
        }
    }
    
    func createTable() {
        let query = "CREATE TABLE IF NOT EXIST wheaterData()"
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("table creation success")
            } else {
                print("table creation fail")
            }
        }else {
            print("preparation fail")
        }
    }
}
