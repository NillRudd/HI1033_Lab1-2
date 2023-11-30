//
//  coordinatesView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import SwiftUI



struct coordinatesView: View {
    @EnvironmentObject var theViewModel : WeatherVM
    var body: some View {
        HStack {
            TextField("Location", text: $theViewModel.locationInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                //.keyboardType(.decimalPad)
                //.keyboardType(.decimalPad)
            Button {
                theViewModel.fetchGeoData()
                
                //theViewModel.saveToCoreData()
                //isSettingsViewActive = false
            }label: {
                Text("Submit")
                    .padding(7)
            }
            
            .background(Color(red: 0.8, green: 0.8, blue: 0.8))
                .cornerRadius(5)
                .foregroundColor(.black)
                .shadow(radius: 1.5, x: 1.5, y:1.5)
            VStack {
                Text("\(theViewModel.latitude)")
                Text("\(theViewModel.longitude)")
            }
        }
        .padding(7)
        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
    }
}

struct coordinatesView_Previews: PreviewProvider {
    static var previews: some View {
        coordinatesView()
            .environmentObject(WeatherVM())
    }
}
