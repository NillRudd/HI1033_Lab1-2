//
//  WeatherVM.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import Foundation
import Network


class WeatherVM : ObservableObject {
    
    @Published private var theModel: WeatherModel
    @Published var locationInput: String = "Stockholm"
    

    var location: String{
        theModel.location
    }
    var latitude: Double {
        theModel.latitude
    }

    var longitude: Double {
        theModel.longitude
    }
    
    var weatherData : WeatherData {
        theModel.weatherData.last ?? WeatherData(
            latitude: 0,
            longitude: 0,
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
    }

    init() {
        theModel = WeatherModel()
        //setupWeatherData()
        testNetwork()
    }

    private func setupWeatherData() {
        DispatchQueue.main.async {
            self.theModel.updateWeatherData()
            //self.weatherData = self.theModel.getWeatherData()
            self.objectWillChange.send()
        }
        
    }

    func getIconWithWeatherCode(code: Int) -> String {
        return theModel.iconFromCode(code: code)
    }
    
    func testNetwork() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("We're connected!")
                    self.theModel.getData()
                } else {
                    print("No connection.")
                }

                self.theModel.updateWeatherData()
                self.setupWeatherData()
                self.objectWillChange.send()
                print(path.isExpensive)
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func fetchGeoData() {
        guard let encodedLocationString = locationInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
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
                            self.theModel.setLocation(location: geoData.place)
                            self.theModel.getData()
                            self.theModel.updateWeatherData()
                            self.objectWillChange.send()
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


