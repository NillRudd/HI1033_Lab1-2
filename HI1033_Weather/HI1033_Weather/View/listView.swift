//
//  listView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import SwiftUI

struct listView: View {
    @EnvironmentObject var VM: WeatherVM
    var body: some View {
        VStack{
            Spacer()
            HStack{
                    Text("Weather Forecast")
                    .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)


            }
            Text("\(VM.location)")
                .font(.title)
            Text("Approved time 2022-07-14")
            List {
                ForEach(VM.weatherData[0].hourly.time.indices, id: \.self) { index in
                    rowView(timestamp: VM.weatherData[0].hourly.time[index],
                            icon: VM.getIconWithWeatherCode(code: VM.weatherData[0].hourly.weatherCode[index]),
                            temp: VM.weatherData[0].hourly.temperature2M[index])
                }
            }
            .listStyle(PlainListStyle())
            
            coordinatesView()
        }
    }
    
}

struct listView_Previews: PreviewProvider {
    static var previews: some View {
        listView().environmentObject(WeatherVM())
    }
}
