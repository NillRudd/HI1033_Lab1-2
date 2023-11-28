//
//  WeatherVM.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-27.
//

import Foundation

class WeatherVM : ObservableObject {
    
    private var theModel : WeatherModel
    private var dbManager : DbManager
    @Published var latitude : String
    @Published var longitude : String
    @Published var time : String
    
    
    init(){
        theModel = WeatherModel()
        dbManager = DbManager()
        latitude = String(theModel.latitude)
        longitude = String(theModel.longitude)
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        time = "Approved time \(dateFormatter.string(from: currentDate))"
        theModel.getData()
        
    }
    
    
    
    
    
}
