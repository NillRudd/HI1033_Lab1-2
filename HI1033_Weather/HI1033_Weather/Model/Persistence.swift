//
//  Persistence.swift
//  HI1033_Weather
//
//  Created by Niklas Roslund on 2023-11-27.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "HI1033_Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            //newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    func saveWeatherData(weatherData: WeatherData) {
        let viewContext = container.viewContext

        // Replace "Item" with the actual name of your entity for the data
        let item = Item(context: viewContext)
        item.latitude = weatherData.latitude
        item.longitude = weatherData.longitude
        item.generationTime = weatherData.generationtimeMS
        item.utcOffset = Int32(weatherData.utcOffsetSeconds)
        item.timezone = weatherData.timezone
        item.timezoneAbbreviation = weatherData.timezoneAbbreviation
        item.elevation = Double(weatherData.elevation)

        // Serialize the hourly weather data and store it in the attribute
        let encoder = JSONEncoder()
        if let hourlyData = try? encoder.encode(weatherData.hourly) {
            item.hourlyWeatherData = hourlyData
        }

        // Save changes to Core Data
        do {
            try viewContext.save()
        } catch {
            fatalError("Unresolved error \(error), \(error.localizedDescription)")
        }
    }
    
    func fetchWeatherData() -> [WeatherData]? {
        let viewContext = container.viewContext
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()

        do {
            let items = try viewContext.fetch(fetchRequest)
            
            // Transform fetched items into WeatherData objects
            let weatherDataArray = items.compactMap { item -> WeatherData? in
                guard let hourlyData = item.hourlyWeatherData else { return nil }
                
                let decoder = JSONDecoder()
                if let hourly = try? decoder.decode(Hourly.self, from: hourlyData) {
                    
                    // Create WeatherData object
                    let weatherData = WeatherData(
                        latitude: item.latitude,
                        longitude: item.longitude,
                        generationtimeMS: item.generationTime,
                        utcOffsetSeconds: Int(item.utcOffset),
                        timezone: item.timezone ?? "",
                        timezoneAbbreviation: item.timezoneAbbreviation ?? "",
                        elevation: Int(item.elevation),
                        hourlyUnits: HourlyUnits(time: "", temperature2M: "", weatherCode: ""),
                        hourly: hourly
                    )
                    return weatherData
                } else {
                    return nil
                }
            }

            return weatherDataArray
        } catch {
            print("Error fetching data: \(error)")
            return nil
        }
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HI1033_Weather")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
