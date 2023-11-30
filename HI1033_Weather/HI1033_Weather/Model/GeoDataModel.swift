//
//  GeoDataModel.swift
//  HI1033_Weather
//
//  Created by Esteban Masaya on 2023-11-29.
//

import Foundation

struct GeoData: Decodable {
    let geonameid: Int
    let place: String
    let population: Int
    let lon: Double
    let lat: Double
    let type: [String]
    let municipality: String
    let county: String
    let country: String
    let district: String
    
    private enum CodingKeys: String, CodingKey {
        case geonameid, place, population, lon, lat, type, municipality, county, country, district
    }
}
