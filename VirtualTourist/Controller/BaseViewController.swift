//
//  BaseViewController.swift
//  VirtualTourist
//
//  Created by Ahmed Sengab on 1/31/19.
//  Copyright © 2019 Ahmed Sengab. All rights reserved.
//

import UIKit
import MapKit

class BaseViewController: UIViewController ,MKMapViewDelegate {
    
    public func ShowAlertMessage(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
 
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let doSomething = view.annotation?.title! {
                print(doSomething)
            }
        }
    }
    
    func setMapPins(pins : [Pin], mapView : MKMapView){
        var annotations = [PinAnnotation]()
        for p in pins {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(p.lat), longitude: CLLocationDegrees(p.lng))
            let annotation = PinAnnotation()
            annotation.coordinate = coordinate
            annotations.append(annotation)
            annotation.pin = p
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
    }
    
    func addAnnotation(location: CLLocationCoordinate2D, mapView : MKMapView){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
}
