//
//  SampleSaleAnnotation.swift
//  SampleSales
//
//  Created by Saul on 10/4/15.
//  Copyright © 2015 Saul. All rights reserved.
//

import Foundation
import MapKit

class SampleSaleAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var sampleSale:SampleSaleModel?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String,sampleSale:SampleSaleModel) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.sampleSale = sampleSale
    }
}
