//
//  ListTableViewCell.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/8.
//  Copyright © 2018 gary chen. All rights reserved.
//

import UIKit


class ListTableViewCell: UITableViewCell {

    //MARK:- Properties
    var delegate: ListViewControllerDelegate?
    var favoriteDelegate: FavoriteTableViewControllerDelegate?
    var userDefault: UserDefaults?
    
    var park: TaipeiPark! {
        didSet {
            parkImageView.setImage(urlString: park.Image)
            parkNameLabel.text = park.ParkName
            administrativeAreaLabel.text = park.AdministrativeArea
            introductionLabel.text = park.Introduction
            
            if UserDefaults.standard.bool(forKey: park.ParkName) {
                favoriteButton.setImage(#imageLiteral(resourceName: "favorite_selected"), for: .normal)
                favoriteButton.isSelected = true
            } else {
                favoriteButton.setImage(#imageLiteral(resourceName: "favorite-1"), for: .normal)
                favoriteButton.isSelected = false
            }

        }
    }
    
    //MARK:- IBOutlets
    @IBOutlet weak var parkImageView: UIImageView!
    @IBOutlet weak var parkNameLabel: UILabel!
    @IBOutlet weak var administrativeAreaLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var introductionLabel: UILabel!

    //MARK:- Cell life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK:- IBActions
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        
        if sender.isSelected {
            UserDefaults.standard.removeObject(forKey: park.ParkName)
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite-1"), for: .normal)
            sender.isSelected = false
        } else {
            UserDefaults.standard.set(true, forKey: park.ParkName)
            favoriteButton.setImage(#imageLiteral(resourceName: "favorite_selected"), for: .normal)
            sender.isSelected = true
        }
        if let favoriteDelegate = favoriteDelegate {
            favoriteDelegate.handleFavoriteButtonTapped(parkName: park.ParkName)
        }

    }
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.handleMapButtonTapped(parkName: park.ParkName)
        } else {
            favoriteDelegate?.handleMapButtonTapped(parkName: park.ParkName)
        }
    }
    
}
