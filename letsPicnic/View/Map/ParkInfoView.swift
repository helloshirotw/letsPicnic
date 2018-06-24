//
//  ParkInfoView.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/14.
//  Copyright © 2018 gary chen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ParkInfoView: UIView {
    
    //MARK:- Properties
    var mapViewController: MapViewControllerDelegate!
    var parkFacilitiesDic = [String: [ParkFacility]]()
    var parkFeaturesDic = [String: [ParkFeature]]()
    var taipeiPark: TaipeiPark! {
        didSet {
            parkNameLabel.text = taipeiPark.ParkName
            parkImageView.setImage(urlString: taipeiPark.Image)
            administrativeAreaLabel.text = taipeiPark?.AdministrativeArea

            setOpenTimeLabels(taipeiPark: taipeiPark)
            
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(parkInfoViewTapped)))
            
        }
    }
    //MARK:- IBOutlets
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var parkImageView: UIImageView!
    @IBOutlet weak var administrativeAreaLabel: UILabel!
    @IBOutlet weak var openStatusLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    
    //MARK: View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderWidth = 4
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    //MARK: Methods
    
    private func setOpenTimeLabels(taipeiPark: TaipeiPark) {
        let openTime = parkFeaturesDic[taipeiPark.ParkName]?.first?.OpenTime
        if openTime == nil {
            openTimeLabel.text = "無資料"
            openStatusLabel.text = "無資料"
            openStatusLabel.textColor = .gray
        } else {
            openTimeLabel.text = openTime
            if (openTime?.isOpenTime())! {
                openStatusLabel.text = "營業中"
                openStatusLabel.textColor = .green
            } else {
                openStatusLabel.text = "閉園中"
                openStatusLabel.textColor = .red
            }
        }
    }
    
    @objc func parkInfoViewTapped(gestureRecognizer: UIGestureRecognizer) {
        mapViewController.parkInfoViewIsTapped(taipeiPark: taipeiPark)
    }
    
    @IBAction func guideButtonTapped(_ sender: UIButton) {
        let latitude = taipeiPark.Latitude
        let longitude = taipeiPark.Longitude
        
        CLGeocoder().startGuide(destination: taipeiPark.ParkName, latitude: Double(latitude)!, longitude: Double(longitude)!)
        
    }
}
