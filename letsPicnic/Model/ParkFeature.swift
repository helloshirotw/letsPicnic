//
//  ParkFeature.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/14.
//  Copyright © 2018 gary chen. All rights reserved.
//

import Foundation

struct FeatureResult: Decodable {
    let result: FeatureResults
}

struct FeatureResults: Decodable {
    let limit: Int
    let offset: Int
    let results: [ParkFeature]
}

struct ParkFeature: Decodable {
    let ParkName: String
    let OpenTime: String
    let Name: String
    let Introduction: String
    let Image: String
}


