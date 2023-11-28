//
//  HI1033_WeatherApp.swift
//  HI1033_Weather
//
//  Created by Niklas Roslund on 2023-11-27.
//

import SwiftUI

@main
struct HI1033_WeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            listView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
