//
//  CLGDecoder.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/21.
//  Copyright © 2018年 gary chen. All rights reserved.
//

import MapKit

extension CLGeocoder {
    func startGuide(destination: String, latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (clPlacemarks, error) in
            if error != nil {
                print(error!)
                
            }
            if let placemarks = clPlacemarks {
                if placemarks.count > 0 {
                    let placemark = MKPlacemark(placemark: placemarks.first!)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = destination
                    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeTransit])
                    
                }
            }
        }
    }
}
