//
//  AlbumViewController.swift
//  VirtualTourist
//
//  Created by Ahmed Sengab on 1/27/19.
//  Copyright © 2019 Ahmed Sengab. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class AlbumViewController: BaseViewController {
    
    let context  = DataFactory.shared.dataController.viewContext
    var fetchedResultsController:NSFetchedResultsController<Photos>!
    var pin : Pin!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var collectioView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        collectioView.delegate = self
        collectioView.dataSource = self
        setMapPins(pins: [pin], mapView: mapView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPhotos()
        if fetchedResultsController.fetchedObjects?.count == 0 {
            downLoadPhotoAlbum()
        }
        newCollectionButton.isEnabled =  fetchedResultsController.fetchedObjects?.count == 0
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func NewCollectionAction(_ sender: Any) {
        for photo in fetchedResultsController!.fetchedObjects!  {
            context.delete(photo)
            try? context.save()
        }
        downLoadPhotoAlbum()
    }
    
    func fetchPhotos()  {
        let fetchRequest:NSFetchRequest<Photos> = Photos.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "createDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Error while retrieving data: \(error.localizedDescription)")
        }
    }
    
    func deletePhoto(index: IndexPath) {
        let photo = fetchedResultsController.object(at: index)
        context.delete(photo)
        try? context.save()
    }
    
    func downLoadPhotoAlbum()
    {
        Client.getPhotosUrl(lat: pin.lat, lon: pin.lng){arr,error in
            if let error = error
            {
                super.ShowAlertMessage(title: "Error", message: error )
                return
            }
            if  arr.count  > 0{
                
                for url in arr {
                    print(url)
                    Client.downloadPhoto(url: url){data,error in
                        if error == nil
                        {
                            if  let data = data{
                                self.SavePhoto(data: data, url: url)
                            }
                        }
                    }
                }
            }else   {super.ShowAlertMessage(title: "", message: "No photos found")}
            
        }
        fetchPhotos()
    }
    
    func SavePhoto(data : Data , url : String) {
        let photo = Photos(context: context)
        photo.imageData  = data
        photo.photoUrl = url
        try? context.save()
    }
    
}


extension AlbumViewController : UICollectionViewDelegate,UICollectionViewDataSource,NSFetchedResultsControllerDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VirtualTouristCollectionViewCell", for: indexPath) as! VirtualTouristCollectionViewCell
        if let _  = fetchedResultsController.fetchedObjects?.count  {
            let photo = fetchedResultsController.object(at: indexPath)
            cell.virtualTouristImageView?.image = UIImage(data: photo.imageData!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        deletePhoto(index:  indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectioView.reloadData()
        newCollectionButton.isEnabled =  fetchedResultsController.fetchedObjects?.count == 0
    }
}
