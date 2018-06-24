//
//  MainTabBarController.swift
//  PodcastsDemo
//
//  Created by Gary Chen on 24/5/2018.
//  Copyright © 2018 Gary Chen. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    //MARK:- Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .purple

        setupViewControllers()

    }
    
    //MARK:- Setup Functions
    
    func setupViewControllers() {
        
        let listTableViewController = ListTableViewController()
        listTableViewController.tabBarItem.title = "列表"
        listTableViewController.tabBarItem.image = #imageLiteral(resourceName: "list")
        
        let mapViewController = MapViewController(nibName: VCConstants.MAP, bundle: nil)
        mapViewController.tabBarItem.title = "地圖"
        mapViewController.tabBarItem.image = #imageLiteral(resourceName: "map")
        
        let favoriteTableViewController = FavoriteTableViewController()
        favoriteTableViewController.tabBarItem.title = "我的最愛"
        favoriteTableViewController.tabBarItem.image = #imageLiteral(resourceName: "favorite")
        
        viewControllers = [listTableViewController, mapViewController, favoriteTableViewController]

    }    
}
