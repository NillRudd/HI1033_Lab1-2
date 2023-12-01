//
//  Persistence.swift
//  HI1033_Weather
//
//  Created by Niklas Roslund on 2023-11-27.
//

import CoreData
import Foundation

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

    func saveWeatherData(weatherData: WeatherData) {
        clearAllData()
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

        // Serialize the daily weather data and store it in the attribute
        if let dailyData = try? encoder.encode(weatherData.daily) {
            item.dailyWeatherData = dailyData
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
                guard
                    let hourlyData = item.hourlyWeatherData,
                    let dailyData = item.dailyWeatherData
                else {
                    return nil
                }

                let decoder = JSONDecoder()
                if let hourly = try? decoder.decode(Hourly.self, from: hourlyData),
                   let daily = try? decoder.decode(Daily.self, from: dailyData)
                {
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
                        hourly: hourly,
                        dailyUnits: DailyUnits(time: "", weatherCode: "", temperature2MMax: "", temperature2MMin: ""),
                        daily: daily
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
    
    func clearAllData() {
        let viewContext = container.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Item")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()
        } catch {
            print("Error clearing data: \(error)")
        }
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HI1033_Weather")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func fetchAllFavorites() -> [String] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()

        do {
            let favorite = try container.viewContext.fetch(request)
            return favorite.map { $0.place ?? ""}
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
    
    func insertFavoritePlace(name: String) -> Bool{
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "place == %@", name)

        do {
            let existingFavorites = try container.viewContext.fetch(request)

            guard existingFavorites.isEmpty else {
                return false
            }

            let favorite = Favorite(context: container.viewContext)
            favorite.place = name

            do {
                try container.viewContext.save()
                print("Place '\(name)' added to favorites.")
            } catch {
                print("Error saving context: \(error)")
            }
        } catch {
            print("Error fetching favorites: \(error)")
        }
        return true
    }
}
