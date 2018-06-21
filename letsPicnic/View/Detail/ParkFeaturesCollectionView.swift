//
//  ParkFeaturesCollectionViewController.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/20.
//  Copyright © 2018年 gary chen. All rights reserved.
//

import UIKit

extension DetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parkFeatures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellConstants.PARK_FEATURE, for: indexPath) as! ParkFeatureCell
        let parkFeature = parkFeatures[indexPath.item]
        cell.parkFeature = parkFeature
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: IndexPath(item: indexPath.item, section: 0)) as! ParkFeatureCell
        let detailViewController = DetailViewController(nibName: VCConstants.DETAIL, bundle: nil)
        detailViewController.parkFeature = cell.parkFeature
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}

class ParkFeatureCell: UICollectionViewCell {
    
    var parkFeature: ParkFeature! {
        didSet {
            featureParkImageView.setImage(urlString: parkFeature.Image)
            featureNameLabel.text = parkFeature.Name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let featureParkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let featureNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "FeatureName"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        return label
    }()
    
    func setupConstraints() {
        
        addSubview(featureParkImageView)
        featureParkImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        featureParkImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        featureParkImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        featureParkImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        featureParkImageView.addSubview(featureNameLabel)
        featureNameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        featureNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    
    
}
