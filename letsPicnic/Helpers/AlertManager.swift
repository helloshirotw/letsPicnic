//
//  File.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/15.
//  Copyright © 2018年 gary chen. All rights reserved.
//

import UIKit

let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

class AlertManager: NSObject {
    static let shared = AlertManager()
    private var alertController: UIAlertController!
    
    func displayStandardAlert(vc: UIViewController,title: String, message: String, action: UIAlertAction = okAction) {
        if alertController != nil {
            dismissAlert()
        }
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    private func dismissAlert() {
        alertController.dismiss(animated: true, completion: nil)
    }
}
