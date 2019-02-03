//
//  Entity+Extensions.swift
//  VirtualTourist
//
//  Created by Ahmed Sengab on 1/29/19.
//  Copyright © 2019 Ahmed Sengab. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension Pin{
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createDate = Date()
    }
}

extension Photos{
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        createDate = Date()
    }
}

class PinAnnotation: MKPointAnnotation {
    var pin : Pin!
}
