//
//  FavoritesView.swift
//  HI1033_Weather
//
//  Created by Niklas Roslund on 2023-12-01.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var VM: WeatherVM
    @Binding var isFavoritesViewActive: Bool
    @State private var newPlace: String = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(VM.places, id: \.self) { place in
                    HStack {
                        Text(place)
                            .onTapGesture {
                                VM.locationInput = place
                                VM.fetchGeoData()
                                VM.testNetwork()
                                isFavoritesViewActive = false
                            }
                        Spacer()
                        Button(action: {
                            VM.removeFromFavorites(place: place)
                        }) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                HStack {
                    TextField("Add new place", text: $newPlace)
                    Button("Add") {
                        VM.addToFavorites(place: newPlace)
                        newPlace = ""
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Favorites")
            .navigationBarItems(trailing:
                Button("Done") {
                    
                    isFavoritesViewActive = false
                }
            )
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(isFavoritesViewActive: .constant(true))
            .environmentObject(WeatherVM())
    }
}
