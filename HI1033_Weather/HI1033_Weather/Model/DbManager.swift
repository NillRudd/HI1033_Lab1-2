//
//  DbManager.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-28.
//

import SQLite3

import Foundation

struct DbManager {
    var db : OpaquePointer?
    var path : String = "WeatherDB.db"

    init(){
        db = createDB();
        createTable();
    }
    
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("There is error in creating db")
            return nil
        }else {
            print("Database has been created with path \(path)")
            return db
        }
    }
    
    func createTable() {
        let query = """
        CREATE TABLE IF NOT EXISTS weatherData(latitude REAL,
            longitude REAL,
            generationtimeMS REAL,
            utcOffsetSeconds INTEGER,
            timezone TEXT,
            timezoneAbbreviation TEXT,
            elevation INTEGER,
            hourlyTime TEXT,
            hourlyTemperature2M TEXT,
            hourlyWeatherCode TEXT
        );
        """
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("table creation success")
            } else {
                print("table creation fail")
            }
        }else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            print("preparation fail: \(errorMessage)")
        }
        sqlite3_finalize(statement)
    }
    
    func insertWeatherData(weatherData: WeatherData) {
        let query = """
            INSERT INTO weatherData (
                latitude,
                longitude,
                generationtimeMS,
                utcOffsetSeconds,
                timezone,
                timezoneAbbreviation,
                elevation,
                hourlyTime,
                hourlyTemperature2M,
                hourlyWeatherCode
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """

        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            // Bind values to the statement parameters
            sqlite3_bind_double(statement, 1, weatherData.latitude)
            sqlite3_bind_double(statement, 2, weatherData.longitude)
            sqlite3_bind_double(statement, 3, weatherData.generationtimeMS)
            sqlite3_bind_int(statement, 4, Int32(weatherData.utcOffsetSeconds))
            sqlite3_bind_text(statement, 5, weatherData.timezone, -1, nil)
            sqlite3_bind_text(statement, 6, weatherData.timezoneAbbreviation, -1, nil)
            sqlite3_bind_int(statement, 7, Int32(weatherData.elevation))
            sqlite3_bind_text(statement, 8, weatherData.hourly.time.joined(separator: ","), -1, nil)
            sqlite3_bind_text(statement, 9, weatherData.hourly.temperature2M.map { String($0) }.joined(separator: ","), -1, nil)
            sqlite3_bind_text(statement, 10, weatherData.hourly.weatherCode.map { String($0) }.joined(separator: ","), -1, nil)

            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data insertion success")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(self.db))
                print("Data insertion fail: \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            print("Preparation fail: \(errorMessage)")
        }

        sqlite3_finalize(statement)
    }

    func getWeatherData() -> [WeatherData] {
        var weatherDataArray: [WeatherData] = []
        let query = "SELECT * FROM weatherData;"

        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let latitude = sqlite3_column_double(statement, 0)
                let longitude = sqlite3_column_double(statement, 1)
                let generationtimeMS = sqlite3_column_double(statement, 2)
                let utcOffsetSeconds = Int(sqlite3_column_int(statement, 3))
                let timezone = String(cString: sqlite3_column_text(statement, 4))
                let timezoneAbbreviation = String(cString: sqlite3_column_text(statement, 5))
                let elevation = Int(sqlite3_column_int(statement, 6))

                let hourlyTime = String(cString: sqlite3_column_text(statement, 7))
                let hourlyTemperature2M = String(cString: sqlite3_column_text(statement, 8))
                let hourlyWeatherCode = String(cString: sqlite3_column_text(statement, 9))

                // Split the comma-separated strings into arrays
                let hourlyTimeArray = hourlyTime.components(separatedBy: ",")
                let hourlyTemperature2MArray = hourlyTemperature2M.components(separatedBy: ",")
                let hourlyWeatherCodeArray = hourlyWeatherCode.components(separatedBy: ",")

                // Create Hourly instance
                let hourly = Hourly(
                    time: hourlyTimeArray,
                    temperature2M: hourlyTemperature2MArray.compactMap { Double($0) },
                    weatherCode: hourlyWeatherCodeArray.compactMap { Int($0) }
                )

                let weatherData = WeatherData(
                    latitude: latitude,
                    longitude: longitude,
                    generationtimeMS: generationtimeMS,
                    utcOffsetSeconds: utcOffsetSeconds,
                    timezone: timezone,
                    timezoneAbbreviation: timezoneAbbreviation,
                    elevation: elevation,
                    hourly: hourly
                )

                weatherDataArray.append(weatherData)
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            print("Preparation fail: \(errorMessage)")
        }

        sqlite3_finalize(statement)
        return weatherDataArray
    }
}
