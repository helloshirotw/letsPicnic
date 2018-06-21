//
//  ParkFacilities.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/14.
//  Copyright © 2018 gary chen. All rights reserved.
//

import Foundation

struct FacilityResult: Decodable {
    let result: FacilityResults
}

struct FacilityResults: Decodable {
    let results: [ParkFacility]
}

struct ParkFacility: Decodable {
    let facility_name: String
}
