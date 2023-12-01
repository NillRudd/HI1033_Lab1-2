//
//  HourlyDetailView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-12-01.
//

import SwiftUI

struct hourlyDetailView: View {
    @EnvironmentObject var VM: WeatherVM

    let timestamp: String
    let icon : String
    let temp: Double
    
    var body: some View {
        VStack(alignment: .center){
            Text(VM.formatDatetoHour(timestamp: timestamp))
            Text(icon)
            let formattedTemp = String(format: "%.0f", temp)
            Text("\(formattedTemp)°").font(.title2)
        }
        .padding(.horizontal)
    }
}

struct HourlyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        hourlyDetailView(timestamp: "2023-12-06T07:00", icon: "🌞", temp: 15).environmentObject(WeatherVM())
    }
}
