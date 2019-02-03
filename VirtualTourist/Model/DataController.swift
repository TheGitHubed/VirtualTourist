//
//  DataController.swift
//  VirtualTourist
//
//  Created by Ahmed Sengab on 1/29/19.
//  Copyright © 2019 Ahmed Sengab. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer:NSPersistentContainer
    
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }

            completion?()
        }
    }
}

class DataFactory{
    
    static let shared = DataFactory()
    let dataController  = DataController(modelName: "Tourist")
    private init(){}
    
}
