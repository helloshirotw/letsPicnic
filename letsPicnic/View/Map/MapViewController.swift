//
//  MapViewController.swift
//  letsPicnic
//
//  Created by gary chen on 2018/6/8.
//  Copyright © 2018 gary chen. All rights reserved.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate {
    func parkInfoViewIsTapped(taipeiPark: TaipeiPark)
}

class MapViewController: UIViewController {
    
    //MARK:- Properties
    var locationManager = CLLocationManager()
    var taipeiParks = [TaipeiPark]()
    var parkFacilitiesDic = [String: [ParkFacility]]()
    var parkFeaturesDic = [String: [ParkFeature]]()
    var parkInfoView: ParkInfoView?

    //MARK:- IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setAnnotations()
    }
    
    //MARK:- Methods
    //MARK:- Private method
    private func setupMap() {
        mapView.delegate = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragMap))
        panGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
        
        setCLLocation()
    }
    
    private func setCLLocation() {
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        locationManager.startUpdatingLocation()
    }
    

    func getNearestCoordinate(userCoordinate: CLLocationCoordinate2D, taipeiParks: [TaipeiPark]) -> CLLocationCoordinate2D? {
        var nearestCoordinate: CLLocationCoordinate2D!
        var minDistance: Double = 9999999999
        
        for taipeiPark in taipeiParks {
            
            guard let latitude = Double(taipeiPark.Latitude), let longitude = Double(taipeiPark.Longitude) else { return nil }
            // Calculate distance
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let location: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
            let distance = location.distance(from: userLocation)
            
            if distance < minDistance {
                minDistance = distance
                nearestCoordinate = coordinate
            }
        }
        return nearestCoordinate
    }
    
    func setAnnotations() {
        
        mapView.removeAnnotations(mapView.annotations)
        for taipeiPark in taipeiParks {
            
            if let latitude = Double(taipeiPark.Latitude), let longitude = Double(taipeiPark.Longitude) {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

                // Add annotation
                let annotation = CustomPointAnnotation()
                annotation.coordinate = coordinate
                annotation.taipeiPark = taipeiPark
                mapView.addAnnotation(annotation)
            }
        }
    }

    
    func setRegion(center: CLLocationCoordinate2D) {
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
    
}

//MARK:- Map view delegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let view = view as? AnnotationView, let annotation = view.annotation as? CustomPointAnnotation else { return }
        
        setRegion(center: annotation.coordinate)
        setParkInfoView(annotation: annotation)
        addAnnotationGestureRecognizer(view: view)
        
    }
    
    //MARK:- Map view methods
    //MARK:- Private methods
    //MARK:- ParkInfoView
    private func setParkInfoView(annotation: CustomPointAnnotation) {
        parkInfoView = Bundle.main.loadNibNamed(ViewConstants.PARK_INFO, owner: self, options: nil)?.first as? ParkInfoView
        parkInfoView?.mapViewController = self
        parkInfoView?.parkFeaturesDic = parkFeaturesDic
        parkInfoView?.parkFacilitiesDic = parkFacilitiesDic
        parkInfoView?.taipeiPark = annotation.taipeiPark
        
        parkInfoView?.frame = CGRect(x: (mapView.frame.width - 300) / 2 , y: (mapView.frame.height / 2) - 250, width: 300, height: 200)
        
        mapView.addSubview(parkInfoView!)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        parkInfoView?.removeFromSuperview()
    }
    
    //MARK: Annotations
    func addAnnotationGestureRecognizer(view: MKAnnotationView) {
        if let recognizers = view.gestureRecognizers {
            for recognizer in recognizers {
                view.removeGestureRecognizer(recognizer)
            }
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleAddtoFavorite))
        longPress.minimumPressDuration = 0.7
        longPress.delegate = self
        view.addGestureRecognizer(longPress)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotation = annotation as? CustomPointAnnotation else { return nil }

        let parkName = annotation.taipeiPark.ParkName
        let image = getAnnotationImage(parkName: parkName)
        
        let parkFeatures = parkFeaturesDic[parkName]
        let openTime = parkFeatures?.first?.OpenTime

        
        if parkFeatures == nil || openTime == nil {
            
            return AnnotationView(
                frame: CGRect(x: 0, y: 0, width: 50, height: 70), image: image, borderColor: UIColor.gray)
        } else {
            let borderColor = getAnnotationBorderColor(openTime: openTime!)
            return AnnotationView(
                frame: CGRect(x: 0, y: 0, width: 50, height: 70), image: image, borderColor: borderColor)
        }
    }
    
    @objc func handleAddtoFavorite(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            guard let view = gestureRecognizer.view as? AnnotationView else { return }
            guard let annotation = view.annotation as? CustomPointAnnotation else { return }
            let image = view.imageView.image
            
            let parkName = annotation.taipeiPark.ParkName
            
            if image == #imageLiteral(resourceName: "favorite_selected") {
                UserDefaults.standard.removeObject(forKey: parkName)
                view.imageView.image = #imageLiteral(resourceName: "favorite-1")
                AlertManager.shared.displayStandardAlert(vc: self, title: "已從我的最愛中刪除", message: "")
            } else if image == #imageLiteral(resourceName: "favorite-1") {
                UserDefaults.standard.set(true, forKey: parkName)
                view.imageView.image = #imageLiteral(resourceName: "favorite_selected")
                AlertManager.shared.displayStandardAlert(vc: self, title: "已加入我的最愛", message: "")
            }
            
        }
    }
    
    private func getAnnotationImage(parkName: String) -> UIImage {
        if isFavorite(parkName: parkName) {
            return #imageLiteral(resourceName: "favorite_selected")
        } else {
            return #imageLiteral(resourceName: "favorite-1")
        }
    }
    
    private func isFavorite(parkName: String) -> Bool {
        if UserDefaults.standard.bool(forKey: parkName) {
            return true
        } else {
            return false
        }
        
    }
    
    private func getAnnotationBorderColor(openTime: String) -> UIColor {
        
        if openTime.isOpenTime() {
            return UIColor.red
        } else {
            return UIColor.blue
        }
    }
    
    //MARK:- Public methods
    func select(annotation: CustomPointAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    
}

//MARK:- Gesture recognizer
extension MapViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func didDragMap(sender: UIGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            for annotation in mapView.selectedAnnotations {
                mapView.deselectAnnotation(annotation, animated: false)
            }
        }
    }
}

//MARK:- CLLocation delegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate: CLLocationCoordinate2D = manager.location?.coordinate {
            let userCoordinate = coordinate
            //Only update userCoordinate first time entering screen
            locationManager.delegate = nil
            
            let coordinate = getNearestCoordinate(userCoordinate: userCoordinate, taipeiParks: taipeiParks)
            setRegion(center: coordinate!)
            
        }
    }
}

//MARK:- Custom delegate
extension MapViewController: MapViewControllerDelegate {
    func parkInfoViewIsTapped(taipeiPark: TaipeiPark) {
        pushDetailsVC(taipeiPark: taipeiPark)
    }
    
    private func pushDetailsVC(taipeiPark: TaipeiPark) {
        let detailsViewController = DetailsViewController(nibName: VCConstants.DETAILS, bundle: nil)
        detailsViewController.taipeiPark = taipeiPark
        let parkName = taipeiPark.ParkName
        if let parkFacilities = parkFacilitiesDic[parkName], let parkFeatures = parkFeaturesDic[parkName] {
            detailsViewController.parkFacilities = parkFacilities
            detailsViewController.parkFeatures = parkFeatures
        }
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}


class CustomPointAnnotation: MKPointAnnotation {
    var taipeiPark: TaipeiPark!
    var isOpen: Bool!
}
