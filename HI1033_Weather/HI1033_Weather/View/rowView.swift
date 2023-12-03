//
//  rowView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import SwiftUI

struct rowView: View {
    @EnvironmentObject var VM: WeatherVM
    
    let timestamp: String
    let icon : String
    let tempMin: Double
    let tempMax: Double
    var body: some View {
        HStack{

            Text("\(VM.formatDatetoWeekDay(timestamp: timestamp))  ")
            Spacer()
            Text(icon)
            Spacer()
            let formattedTempMin = String(format: "%.0f", tempMin)
            let formattedTempMax = String(format: "%.0f", tempMax)
            Text("\(formattedTempMin)°").font(.title2)
            Spacer()
            Text(" - ").font(.title2)
            Spacer()
            Text("\(formattedTempMax)°").font(.title2)
        }
    }
}

struct rowView_Previews: PreviewProvider {
    static var previews: some View {
        rowView(timestamp: "2023-12-02" , icon: "🌞", tempMin: 15, tempMax:20).environmentObject(WeatherVM())
    }
}
