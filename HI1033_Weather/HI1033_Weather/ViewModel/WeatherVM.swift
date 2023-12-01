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

    var weatherData: [WeatherData]{
        theModel.weatherData
    }
    var location: String{
        theModel.location
    }
    var latitude: Double {
        theModel.latitude
    }

    var longitude: Double {
        theModel.longitude
    }

    init() {
        theModel = WeatherModel()
        testNetwork()
    }

    func getIconWithWeatherCode(code: Int) -> String {
        return theModel.iconFromCode(code: code)
    }
    
    func testNetwork(){
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
                self.getData()
            } else {
                print("No connection.")
            }
            DispatchQueue.main.async {
                self.theModel.updateWeatherData()
            }
            
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    
    func getData() {

        let endpoint = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,weather_code")!
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        let task = session.dataTask(with: endpoint) { (data, response, error ) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else if let data = data {
                if String(data: data, encoding: .utf8) != nil {
                    if let jsonData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                        DispatchQueue.main.async {
                            print("HOLA \(jsonData)")
                            self.theModel.persistenceController.saveWeatherData(weatherData: jsonData)
                            self.theModel.updateWeatherData()

                        }
                    } else {
                        print("Failed to decode JSON into WeatherData")
                    }
                }
            }
        }
        task.resume()
        
        session.finishTasksAndInvalidate()
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
                //print(jsonArray )
                if let firstJson = jsonArray.first {
                    do {
                        let geoData = try JSONDecoder().decode(GeoData.self, from: JSONSerialization.data(withJSONObject: firstJson))
                        DispatchQueue.main.async {
                            //print("geodata: \(geoData)")
                            self.theModel.setCoordinates(latitude: geoData.lat, longitude: geoData.lon)
                            self.theModel.setLocation(location: geoData.place)
                            self.getData()
                            print("finito")
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


