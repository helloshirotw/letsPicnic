//
//  AnnotationView.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/14.
//  Copyright © 2018 gary chen. All rights reserved.
//

import UIKit
import MapKit
class AnnotationView: MKAnnotationView {
    
    var img: UIImage!
    var borderColor: UIColor!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
   
    }
    
    convenience init(frame: CGRect, image: UIImage, borderColor: UIColor) {
        self.init(frame: frame)

        self.img = image
        self.borderColor = borderColor

        addSubview(view)
        view.addSubview(imageView)
        addSubview(downArrowLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var view: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        view.layer.cornerRadius = 25
        view.layer.borderColor = borderColor?.cgColor
        view.layer.borderWidth = 5
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: img)
        imageView.frame = CGRect(x: 7.5, y: 7.5, width: view.frame.width * 0.7, height: view.frame.height * 0.7)
        
        return imageView
    }()

    
    lazy var downArrowLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 45, width: 50, height: 10))
        label.text = "▾"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = borderColor
        label.textAlignment = .center
        return label
    }()
    
}
