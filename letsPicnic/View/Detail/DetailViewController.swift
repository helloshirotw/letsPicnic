//
//  DetailViewController.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/21.
//  Copyright © 2018年 gary chen. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    //MARK:- Properties
    var parkFeature: ParkFeature!
    
    //MARK:- IBOutlets
    @IBOutlet weak var featureImageView: UIImageView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var featureNameLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupOutlets()
    }

    //MARK:- Methods
    private func setupOutlets() {
        featureImageView.setImage(urlString: parkFeature.Image)
        parkNameLabel.text = parkFeature.ParkName
        featureNameLabel.text = parkFeature.Name
        openTimeLabel.text = parkFeature.OpenTime
        introductionLabel.text = parkFeature.Introduction
    }
    
}
