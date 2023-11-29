//
//  GeoDataModel.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-29.
//

import Foundation

struct GeoData: Codable {
    let geonameid: Int
    let place: String
    let population: Int
    let lon, lat: Double
    let type: [String]
    let municipality: String
    let county: String
    let country: String
    let district: String
}
