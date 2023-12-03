//
//  WeatherModel.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import Foundation



struct WeatherModel {

    private (set) var latitude : Double
    private (set) var longitude : Double
    //private (set) var weatherData : [WeatherData] = []
    private (set) var places : [String] = []
    private (set) var location = "Stockholm"
    var geoData : [GeoData] = []
    private (set) var lastUpdated: Date = Date.now
    private var persistanceController : PersistenceController
    
    init(latitude: Double = 59.3293, longitude: Double = 18.0686) {
        self.latitude = latitude
        self.longitude = longitude
        persistanceController = PersistenceController()
        places = persistanceController.fetchAllFavorites()
    }
    
    mutating func setLastUpdated(){
        lastUpdated = Date.now
    }

    mutating func setCoordinates(latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    mutating func addPlace(place : String) {
        if !place.isEmpty {
            if persistanceController.insertFavoritePlace(name: place) == true {
                places.append(place)
            }
        }
    }
    
    mutating func removePlace(place: String) {
        persistanceController.removeFromFavorites(place: place)
        if places.count == 1 {
            places.removeFirst()
            return
        }
        for index in 0...places.count-1 {
            if places[index] == place {
                places.remove(at: index)
                return
            }
        }
    }
    
    
    mutating func setLocation(location: String){
        self.location = location
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
}
