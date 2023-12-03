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
    @Published var weatherData : WeatherData
    @Published var isConnected : Bool = true
    private var persistenceController : PersistenceController
    
    var places : [String] {
        theModel.places
    }
    
    var lastUpdated: Date{
        theModel.lastUpdated
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
        persistenceController = PersistenceController()
        weatherData = WeatherData()
        testNetwork()
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
                    
                    self.fetchGeoData { success in
                        if success {
                            self.getDataFromWeb()
                            self.theModel.setLastUpdated()
                            self.isConnected = true
                        } else {
                            self.getDataFromPersistence()
                            self.isConnected = false
                        }
                    }
                    
                } else {
                    self.getDataFromPersistence()
                    self.isConnected = false
                    print("No connection.")
                }
                print(path.isExpensive)
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func fetchGeoData(completion: @escaping (Bool) -> Void) {
            guard let encodedLocationString = locationInput.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Failed to encode location string")
                completion(false)
                return
            }
            guard let endpoint = URL(string: "https://www.smhi.se/wpt-a/backend_solr/autocomplete/search/\(encodedLocationString)") else {
                print("Invalid URL")
                completion(false)
                return
            }
            let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
                if let error = error {
                    print("Network request error: \(error)")
                    completion(false)
                    return
                }
                guard let data = data else {
                    print("No data received")
                    completion(false)
                    return
                }
                do {
                    print("Decoding JSON...")
                    guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
                        print("Failed to parse JSON as an array of dictionaries")
                        completion(false)
                        return
                    }
                    if let firstJson = jsonArray.first {
                        do {
                            let geoData = try JSONDecoder().decode(GeoData.self, from: JSONSerialization.data(withJSONObject: firstJson))
                            DispatchQueue.main.async {
                                self.theModel.setCoordinates(latitude: geoData.lat, longitude: geoData.lon)
                                self.theModel.setLocation(location: geoData.place)
                                self.objectWillChange.send()
                                print("geodata Updated")
                                completion(true)
                            }
                            
                        } catch {
                            print("Failed to decode GeoData for JSON: \(firstJson), Error: \(error)")
                            completion(false)
                        }
                    }
                } catch {
                    print("Failed to parse JSON: \(error)")
                    completion(false)
                }
            }
            task.resume()
        }
        
        func getDataFromWeb() {
            print("start getting weather")
            let endpoint = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&hourly=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=GMT")!
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig)
            
            let task = session.dataTask(with: endpoint) { (data, response, error) in
                if let error = error {
                    print("error: \(error.localizedDescription)")
                } else if let data = data {
                    if var jsonData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                        self.persistenceController.saveWeatherData(weatherData: jsonData)
                        DispatchQueue.main.async {
                            jsonData.timestamp = Date.now
                            self.weatherData = jsonData
                            print("updating weather")
                        }
                    } else {
                        print("Failed to decode JSON into WeatherData")
                    }
                }
            }
            task.resume()
            
            session.finishTasksAndInvalidate()
            print("finished get data")
        }
        
        func getDataFromPersistence() {
            self.weatherData = persistenceController.fetchWeatherData()?.last ?? WeatherData()
        }
        
        func formatDatetoHour(timestamp: String) -> String{
            let dateFormatter = DateFormatter()
            var hour = ""
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
            if let date = dateFormatter.date(from: timestamp) {
                let calendar = Calendar.current
                hour = String(calendar.component(.hour, from: date))
            } else {
                //print("Failed to parse the date string: \(timestamp)")
            }
            return hour
        }
        
        func formatDatetoWeekDay(timestamp: String) -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: timestamp){
                dateFormatter.dateFormat = "EEEE"
                return dateFormatter.string(from: date)
            } else {
                //print("Failed to parse the date string to a WeekDay: \(timestamp)")
            }
            return ""
        }
        
        func addToFavorites(place: String) {
            theModel.addPlace(place: place)
        }
        
        func removeFromFavorites(place: String) {
            theModel.removePlace(place: place)
        }
        
        func formatDateLastUpdated(timestamp: Date) -> String{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.string(from: timestamp)
        }
    }
    
    extension String {
        func localized() -> String {
            NSLocalizedString(self, comment: "")
        }
    }
    
