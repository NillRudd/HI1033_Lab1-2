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
            HStack{
                Text("Weather Forecast")
                    .foregroundColor(.white)
                    .background(.blue)
                    .padding()
                    .frame(alignment: .leading)
            }
            Text("Approved time 2022-07-14")
            List{
                ForEach (0..<15) { index in
                    rowView(timestamp: Date.now, icon: "☁️", temp: 18)
                }
                
            }.listStyle(PlainListStyle())
            
            coordinatesView().environmentObject(WeatherVM())
        }
    }
    
}

struct listView_Previews: PreviewProvider {
    static var previews: some View {
        listView().environmentObject(WeatherVM())
    }
}
