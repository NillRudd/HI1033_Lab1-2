//
//  listView.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import SwiftUI

struct weatherView: View {
    @EnvironmentObject var VM: WeatherVM
    @State var isFavoritesViewActive = false
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Text("Weather Forecast")
                .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .foregroundColor(.white)
            }
            .background(.blue)

            ZStack {Button(action: {
                isFavoritesViewActive = true
            }) {
                Image(systemName:"gearshape.fill")
            }.fullScreenCover(isPresented:  $isFavoritesViewActive) {
                FavoritesView(isFavoritesViewActive: $isFavoritesViewActive)
                    .environmentObject(VM)
            }.frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
                    .font(.title2)
                VStack {
                    HStack {
                        Text("\(VM.location)")
                            .font(.title)
                            .frame(alignment: .center)
                        
                        
                    }
                    if(!VM.isConnected){
                        Text("No Internet Connection").foregroundColor(.red)
                    }
                    Text("Last updated \(VM.formatDateLastUpdated(timestamp: VM.lastUpdated))")
                }
            }
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
