//
//  WeatherDataModel.swift
//  HI1033_Weather
//
//  Created by Niklas Roslund on 2023-11-28.
//

//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct WeatherData: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let hourlyUnits: HourlyUnits
    let hourly: Hourly
    let dailyUnits: DailyUnits
    let daily: Daily
    var timestamp: Date?
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case hourlyUnits = "hourly_units"
        case hourly
        case dailyUnits = "daily_units"
        case daily
        case timestamp
    }
    init(latitude: Double, longitude: Double, generationtimeMS: Double, utcOffsetSeconds: Int, timezone: String, timezoneAbbreviation: String, elevation: Int, hourlyUnits: HourlyUnits, hourly: Hourly, dailyUnits: DailyUnits, daily: Daily, timestamp: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.generationtimeMS = generationtimeMS
        self.utcOffsetSeconds = utcOffsetSeconds
        self.timezone = timezone
        self.timezoneAbbreviation = timezoneAbbreviation
        self.elevation = elevation
        self.hourlyUnits = hourlyUnits
        self.hourly = hourly
        self.dailyUnits = dailyUnits
        self.daily = daily
        self.timestamp = timestamp
    }
    init() {
        self.latitude = 0.0
        self.longitude = 0.0
        self.generationtimeMS = 0.0
        self.utcOffsetSeconds = 0
        self.timezone = ""
        self.timezoneAbbreviation = ""
        self.elevation = 0
        self.hourlyUnits = HourlyUnits(time: "", temperature2M: "", weatherCode: "")
        self.hourly = Hourly(time: [""], temperature2M: [0.0], weatherCode: [0])
        self.dailyUnits = DailyUnits(time: "", weatherCode: "", temperature2MMax: "", temperature2MMin: "")
        self.daily = Daily(time: [""], weatherCode: [0], temperature2MMax: [0.0], temperature2MMin: [0.0])
        self.timestamp = Date.now
    }
}

struct Daily: Codable {
    let time: [String]
    let weatherCode: [Int]
    let temperature2MMax, temperature2MMin: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
    }
}

struct DailyUnits: Codable {
    let time, weatherCode, temperature2MMax, temperature2MMin: String

    enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
    }
}

struct Hourly: Codable {
    let time: [String]
    let temperature2M: [Double]
    let weatherCode: [Int]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case weatherCode = "weather_code"
    }
}

struct HourlyUnits: Codable {
    let time, temperature2M, weatherCode: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
        case weatherCode = "weather_code"
    }
}




