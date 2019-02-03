//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Ahmed Sengab on 1/27/19.
//  Copyright © 2019 Ahmed Sengab. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: BaseViewController {
    
    let context  = DataFactory.shared.dataController.viewContext
    var pins : [Pin] = []
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPins()
        setMapPins(pins: pins, mapView: mapView)
    }
    
    func fetchPins()  {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let result = try? context.fetch(fetchRequest) {
            pins = result
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let albumController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
        albumController.pin = (view.annotation as! PinAnnotation).pin
        present(albumController, animated: true, completion: nil)
        
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
        
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            savePin(lat: locationOnMap.latitude,lng: locationOnMap.longitude)
            addAnnotation(location: locationOnMap,mapView: mapView)
        }
        
    }

    func savePin(lat: Double,lng: Double) {
        let pin = Pin(context: self.context)
        pin.lat = lat
        pin.lng = lng
        try? self.context.save()
        
    }
    
    
    
}
