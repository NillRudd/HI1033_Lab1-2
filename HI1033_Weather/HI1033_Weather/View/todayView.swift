//
//  TodayView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-12-01.
//

import SwiftUI

struct todayView: View {
    @EnvironmentObject var VM: WeatherVM

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
        HStack{
                ForEach(VM.weatherData.hourly.time.prefix(24), id: \.self) { timestamp in
                    if let index = VM.weatherData.hourly.time.firstIndex(of: timestamp) {
                        hourlyDetailView(
                            timestamp: VM.weatherData.hourly.time[index],
                            icon: VM.getIconWithWeatherCode(code: VM.weatherData.hourly.weatherCode[index]),
                            temp: VM.weatherData.hourly.temperature2M[index]
                        )
                    }
                }
            }
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        todayView().environmentObject(WeatherVM())
    }
}
