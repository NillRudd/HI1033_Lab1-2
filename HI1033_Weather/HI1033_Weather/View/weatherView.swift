//
//  listView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import SwiftUI

struct weatherView: View {
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
            todayView().padding(.vertical)
            
            listView()
            
            coordinatesView()
        }
    }
    
}

struct listView_Previews: PreviewProvider {
    static var previews: some View {
        weatherView().environmentObject(WeatherVM())
    }
}
