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
        CREATE TABLE IF NOT EXIST wheaterData(latitude REAL,
            longitude REAL,
            generationtimeMS REAL,
            utcOffsetSeconds INTEGER,
            timezone TEXT,
            timezoneAbbreviation TEXT,
            elevation INTEGER,
            hourlyUnitsTime TEXT,
            hourlyUnitsTemperature2M TEXT,
            hourlyUnitsWeatherCode TEXT,
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
    }
}
