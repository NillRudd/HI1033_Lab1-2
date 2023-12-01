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
    private (set) var weatherData : [WeatherData] = []
    private (set) var location = "Stockholm"
    var geoData : [GeoData] = []
    private (set) var persistenceController : PersistenceController
    
    init(latitude: Double = 59.3293, longitude: Double = 18.0686) {
        self.latitude = latitude
        self.longitude = longitude
        persistenceController = PersistenceController()
        /*
        let newWeatherData = WeatherData(
            latitude: latitude,
            longitude: longitude,
            generationtimeMS: 0.0,
            utcOffsetSeconds: 0,
            timezone: "UTC",
            timezoneAbbreviation: "UTC",
            elevation: 0,
            hourlyUnits: HourlyUnits(time: "", temperature2M: "", weatherCode: ""),
            hourly: Hourly(time: [""], temperature2M: [0.0], weatherCode: [0]),
            dailyUnits: DailyUnits(time: "", weatherCode: "", temperature2MMax: "", temperature2MMin: ""),
            daily: Daily(time: [""], weatherCode: [0], temperature2MMax: [0.0], temperature2MMin: [0.0])
        )
        weatherData.append(newWeatherData)
        */
    }
    
    func getWeatherData() -> WeatherData{
        return weatherData[weatherData.count-1]
    }
    

    mutating func setCoordinates(latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    mutating func setLocation(location: String){
        self.location = location
    }
    
    func getData() {

        //let endpoint = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,weather_code")!
        let endpoint = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=GMT")!
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: endpoint) { (data, response, error ) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let data = data {
                if String(data: data, encoding: .utf8) != nil {
                    if let jsonData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                        persistenceController.saveWeatherData(weatherData: jsonData)
                        
                    } else {
                        print("Failed to decode JSON into WeatherData")
                    }
                }
            }
        }
        task.resume()
        
        session.finishTasksAndInvalidate()
        print("finished get data")
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
        self.weatherData = persistenceController.fetchWeatherData()!
    }
}
