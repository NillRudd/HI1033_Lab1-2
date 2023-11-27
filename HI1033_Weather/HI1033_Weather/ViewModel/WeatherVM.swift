//
//  WeatherVM.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import Foundation

class WeatherVM : ObservableObject {
    
    private var theModel : WeatherModel
    @Published var latitude : Double
    @Published var longitude : Double
    
    
    init(){
        theModel = WeatherModel()
        latitude = theModel.latitude
        longitude = theModel.longitude
    }
    
    
    
    
    
    
}
