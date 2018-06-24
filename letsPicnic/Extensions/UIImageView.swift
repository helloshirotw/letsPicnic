//
//  UIImageView.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/11.
//  Copyright © 2018 gary chen. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    // Url -> Get imageCache -> setImage
    //     -> Download to imageCache -> setImage
    func setImage(urlString: String) {
        self.image = nil
        
        if let cacheImage = imageCache.object(forKey: urlString as NSString ) {
            self.image = cacheImage
        } else {
            downloadImage(urlString: urlString)
        }
    }
    
    func downloadImage(urlString: String) {
        
        let url = URL(string: urlString)
        guard url != nil else { return }
        URLSession.shared.dataTask(with: url!) { (data, response, error) in

            DispatchQueue.main.async {
                if let okData = data {
                    guard let downloadedImage = UIImage(data: okData) else { return }
                    imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                    self.image = downloadedImage
                } else {
                    self.image = #imageLiteral(resourceName: "default_park")
                }
            }
            
        }.resume()
    }
}
