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
        HStack {
            TextField("Latitude", text: $VM.latitude)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                //.keyboardType(.decimalPad)

            TextField("Longitude", text: $VM.longitude)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                //.keyboardType(.decimalPad)
            Button("Submit") {
                //theViewModel.saveToCoreData()
                //isSettingsViewActive = false
            }.background(.blue)
                .cornerRadius(5)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color.gray)
    }
}

struct coordinatesView_Previews: PreviewProvider {
    static var previews: some View {
        coordinatesView()
            .environmentObject(WeatherVM())
    }
}
