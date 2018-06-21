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

//    var favoriteParkRef = [String: Int]()
//    var favoriteParks = [TaipeiPark]()
    var favoriteParksDic = [String: TaipeiPark]()
    var favoriteParksArray = [TaipeiPark]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: CellConstants.LIST, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CellConstants.LIST)
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteParksDic.count
//        return favoriteParks.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellConstants.LIST, for: indexPath) as! ListTableViewCell
        cell.favoriteDelegate = self
        let park = favoriteParksArray[indexPath.row]
//        let park = favoriteParks[indexPath.row]
//        let parkName = park.ParkName
        cell.park = park

        return cell
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? ListTableViewCell
//        let text = favoriteParksDic[parkName!]?.Introduction
//        let parkName = cell?.park.ParkName
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
    
    private func estimatedFrame(text: String) -> CGRect {
        let size = CGSize(width: 100, height: 100)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let frame = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)], context: nil)
        return frame
    }
    
}

extension FavoriteTableViewController: FavoriteTableViewControllerDelegate {
    
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
        
//        if let index = favoriteParkRef.values.index(of: tag) {
//            let key = favoriteParkRef.keys[index]
//
//            favoriteParks.remove(at: favoriteParks.index{$0.ParkName == key}!)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
    }
}

