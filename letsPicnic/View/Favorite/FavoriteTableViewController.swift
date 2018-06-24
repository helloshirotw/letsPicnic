//
//  FavoriteViewController.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/8.
//  Copyright © 2018 gary chen. All rights reserved.
//

import UIKit

protocol FavoriteTableViewControllerDelegate {
    func handleMapButtonTapped(parkName: String)
    func handleFavoriteButtonTapped(parkName: String)
}

class FavoriteTableViewController: UITableViewController {

    //MARK:- Properties
    var favoriteParksDic = [String: TaipeiPark]()
    var favoriteParksArray = [TaipeiPark]()
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDefaults()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

    //MARK:- Tableview life cycle
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteParksDic.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellConstants.LIST, for: indexPath) as! ListTableViewCell
        cell.favoriteDelegate = self
        let park = favoriteParksArray[indexPath.row]
        cell.park = park

        return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = favoriteParksArray[indexPath.row].Introduction
        let height = estimatedFrame(text: text).height
        if height > 100 {
            return 200
        } else if height < 30 {
            return 135
        } else {
            return height + 100
        }
    }
    
    //MARK:- Methods
    private func estimatedFrame(text: String) -> CGRect {
        let size = CGSize(width: 100, height: 100)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let frame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], context: nil)
        return frame
    }
    
    private func setupDefaults() {
        let nib = UINib(nibName: CellConstants.LIST, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CellConstants.LIST)
    }
}

extension FavoriteTableViewController: FavoriteTableViewControllerDelegate {
    
    //MARK:- Custom delegate
    func handleMapButtonTapped(parkName: String) {
        tabBarController?.selectedIndex = 1
        let mapViewController = tabBarController?.viewControllers![1] as! MapViewController
        
        for annotation in mapViewController.mapView.annotations {
            if let annotation = annotation as? CustomPointAnnotation {
                if annotation.taipeiPark.ParkName == parkName {
                    mapViewController.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
    
    func handleFavoriteButtonTapped(parkName: String) {

        UserDefaults.standard.removeObject(forKey: parkName)
        favoriteParksDic[parkName] = nil
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

