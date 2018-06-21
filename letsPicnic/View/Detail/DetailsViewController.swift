//
//  DetailsViewController.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/17.
//  Copyright © 2018年 gary chen. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {

    var parkFacilities = [ParkFacility]()
    var taipeiPark: TaipeiPark!
    var parkFeatures = [ParkFeature]()
    
    @IBOutlet weak var parkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var parkTypeLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var facilityLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        parkImageView.setImage(urlString: taipeiPark.Image)
        nameLabel.text = taipeiPark.ParkName
        parkTypeLabel.text = taipeiPark.ParkType
        areaLabel.text = taipeiPark.AdministrativeArea
        locationLabel.text = taipeiPark.Location
        openTimeLabel.text = parkFeatures.first?.OpenTime
        introductionLabel.text = taipeiPark.Introduction
        facilityLabel.text = ""
        for parkFacility in parkFacilities {
            let name = parkFacility.facility_name
            facilityLabel.text?.append("\(name), ")
        }
        
        collectionView.register(ParkFeatureCell.self, forCellWithReuseIdentifier: CellConstants.PARK_FEATURE)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "導航", style: .plain, target: self, action: #selector(mapBarButtonTapped))
    }
    
    @objc func mapBarButtonTapped() {
        let latitude = Double(taipeiPark.Latitude)
        let longitude = Double(taipeiPark.Longitude)
        CLGeocoder().startGuide(destination: taipeiPark.ParkName, latitude: latitude!, longitude: longitude!)
    }

}
