//
//  coordinatesView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import SwiftUI



struct coordinatesView: View {
    @EnvironmentObject var VM : WeatherVM
    
    var body: some View {
        HStack{
            TextField("latitude", value: $VM.latitude, format: .number)
            TextField("longitude", value: $VM.longitude, format: .number)
            
        }.background(.gray)
    }
}

struct coordinatesView_Previews: PreviewProvider {
    static var previews: some View {
        coordinatesView()
            .environmentObject(WeatherVM())
    }
}
