//
//  TaipeiPark.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/9.
//  Copyright © 2018 gary chen. All rights reserved.
//

import Foundation

struct ParkResult: Decodable {
    let result: ParkResults
}

struct ParkResults: Decodable {
    let limit: Int
    let offset: Int
    let results: [TaipeiPark]
}

struct TaipeiPark: Decodable {
    let ParkName: String
    let AdministrativeArea: String
    let Image: String
    let Introduction: String
    let Latitude: String
    let Longitude: String
    let ParkType: String
    let Location: String
    
}

struct FavoritePark {
    let tag: Int
}

