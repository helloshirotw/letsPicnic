//
//  ListViewController.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/8.
//  Copyright © 2018 gary chen. All rights reserved.
//

import UIKit
import MapKit

protocol ListViewControllerDelegate {
    func handleMapButtonTapped(parkName: String)
}

class ListTableViewController: UITableViewController {

    var allTaipeiParks = [TaipeiPark]()
    var taipeiParks = [TaipeiPark]()
    var parkFacilitiesDic = [String: [ParkFacility]]()
    var parkFeaturesDic = [String: [ParkFeature]]()
    
    var offset = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.delegate = self
        let nib = UINib(nibName: CellConstants.LIST, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CellConstants.LIST)
        setParks()
        setAllParks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setParks() {
        
        APIService.shared.fetchPark(offset: offset) { (taipeiParks) in
            self.taipeiParks = taipeiParks

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func setAllParks() {
        APIService.shared.fetchPark { (allTaipeiParks) in
            self.allTaipeiParks = allTaipeiParks
        }
    }
    
    func addParks() {
        APIService.shared.fetchPark(offset: offset) { (taipeiParks) in
            self.taipeiParks.append(contentsOf: taipeiParks)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.tableFooterView?.isHidden = true
            }
            
        }
    }
    
}

extension ListTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as? ListTableViewCell
        let parkName = cell?.park.ParkName
        let parkFacilities = parkFacilitiesDic[parkName!]
        let parkFeatures = parkFeaturesDic[parkName!]
        
        let detailsViewController = DetailsViewController(nibName: VCConstants.DETAILS, bundle: nil)
        detailsViewController.taipeiPark = cell?.park
        detailsViewController.parkFacilities = parkFacilities!
        detailsViewController.parkFeatures = parkFeatures!
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let text = taipeiParks[indexPath.row].Introduction
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taipeiParks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellConstants.LIST, for: indexPath) as! ListTableViewCell
        cell.delegate = self
        cell.park = taipeiParks[indexPath.row]
        cell.tag = indexPath.row
        let parkName = taipeiParks[indexPath.row].ParkName
        APIService.shared.fetchFeature(parkname: parkName) { (parkFeatures) in
            self.parkFeaturesDic[parkName] = parkFeatures
        }
        APIService.shared.fetchFacility(parkname: parkName) { (parkfacilities) in
            self.parkFacilitiesDic[parkName] = parkfacilities
        }
        return cell
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = IndexPath(row: taipeiParks.count - 1, section: 0)
        addDataOnBottom(indexPath: indexPath)
    }
    
    func addDataOnBottom(indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if tableView.visibleCells.contains(cell)  {
                offset += 1
                prepareBottomIndicator()
                addParks()
            }
        }
    }
    
    private func prepareBottomIndicator() {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.startAnimating()
        self.tableView.tableFooterView = spinner
        self.tableView.tableFooterView?.isHidden = false
    }
    
}

extension ListTableViewController: UITabBarControllerDelegate {
    
    
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        let tabBarIndex = tabBarController.selectedIndex
        
        if tabBarIndex == 1 {
            let mapViewController = tabBarController.viewControllers![1] as! MapViewController
            mapViewController.taipeiParks = taipeiParks
            mapViewController.parkFeaturesDic = parkFeaturesDic
            mapViewController.parkFacilitiesDic = parkFacilitiesDic

        } else if tabBarIndex == 2 {
            let favoriteTableViewController = tabBarController.viewControllers![2] as! FavoriteTableViewController
            var favoriteParksDic = [String: TaipeiPark]()
            
            for taipeiPark in allTaipeiParks {
                if UserDefaults.standard.bool(forKey: taipeiPark.ParkName) {
                    favoriteParksDic[taipeiPark.ParkName] = taipeiPark
                }
            }
            favoriteTableViewController.favoriteParksDic = favoriteParksDic
            let favoriteParksArray = favoriteParksDic.map {$0.value}
            favoriteTableViewController.favoriteParksArray = favoriteParksArray
        }
    }
    
}

extension ListTableViewController: ListViewControllerDelegate {

    func handleMapButtonTapped(parkName: String) {
        tabBarController?.selectedIndex = 1
        let mapViewController = tabBarController?.viewControllers![1] as! MapViewController

        mapViewController.taipeiParks = taipeiParks
        mapViewController.parkFeaturesDic = parkFeaturesDic
        mapViewController.parkFacilitiesDic = parkFacilitiesDic
        
        for annotation in mapViewController.mapView.annotations {
            if let annotation = annotation as? CustomPointAnnotation {
                if annotation.taipeiPark.ParkName == parkName {
                    mapViewController.select(annotation: annotation)
//                    mapViewController.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
    }
}
