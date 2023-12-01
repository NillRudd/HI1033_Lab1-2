//
//  ListView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-12-01.
//

import SwiftUI

struct listView: View {
    @EnvironmentObject var VM: WeatherVM

    var body: some View {
        List {
            ForEach(VM.weatherData.daily.time.prefix(24), id: \.self) { timestamp in
                if let index = VM.weatherData.daily.time.firstIndex(of: timestamp) {
                    rowView(
                        timestamp: VM.weatherData.daily.time[index],
                        icon: VM.getIconWithWeatherCode(code: VM.weatherData.daily.weatherCode[index]),
                        tempMin: VM.weatherData.daily.temperature2MMin[index],
                        tempMax: VM.weatherData.daily.temperature2MMax[index]
                    ).padding(.vertical)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        listView().environmentObject(WeatherVM())
    }
}
