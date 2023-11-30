//
//  WeatherVM.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import Foundation

class WeatherVM : ObservableObject {
    
    @Published private var theModel: WeatherModel
    @Published var locationString: String = "Stockholm"
    @Published var weatherData: WeatherData

    var latitude: Double {
        theModel.latitude
    }

    var longitude: Double {
        theModel.longitude
    }

    init() {
        theModel = WeatherModel()
        weatherData = WeatherData(
            latitude: 59.3293,
            longitude: 18.0686,
            generationtimeMS: 0.0,
            utcOffsetSeconds: 0,
            timezone: "UTC",
            timezoneAbbreviation: "UTC",
            elevation: 0,
            hourlyUnits: HourlyUnits(time: "", temperature2M: "", weatherCode: ""),
            hourly: Hourly(time: [""], temperature2M: [0.0], weatherCode: [0]))
        setupWeatherData()
    }

    private func setupWeatherData() {
        weatherData = theModel.getWeatherData()
    }

    
    func fetchGeoData() {
        guard let encodedLocationString = locationString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode location string")
            return
        }
        guard let endpoint = URL(string: "https://www.smhi.se/wpt-a/backend_solr/autocomplete/search/\(encodedLocationString)") else {
            print("Invalid URL")
            return
        }
        let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
            if let error = error {
                print("Network request error: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                print("Decoding JSON...")
                guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                    print("Failed to parse JSON as array of dictionaries")
                    return
                }
                print(jsonArray )
                if let firstJson = jsonArray.first {
                    do {
                        let geoData = try JSONDecoder().decode(GeoData.self, from: JSONSerialization.data(withJSONObject: firstJson))
                        DispatchQueue.main.async {
                            //print("geodata: \(geoData)")
                          self.theModel.setCoordinates(latitude: geoData.lat, longitude: geoData.lon)

                        }
                        
                    } catch {
                        print("Failed to decode GeoData for JSON: \(firstJson), Error: \(error)")
                    }
                }
                
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }

        task.resume()
        
    }
}


