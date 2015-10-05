//
//  SampleSaleModel.swift
//  SampleSales
//
//  Created by Saul on 10/4/15.
//  Copyright © 2015 Saul. All rights reserved.
//

import UIKit
import MapKit

class SampleSaleModel: NSObject {
    
    dynamic var address = ""
    dynamic var title = ""
    dynamic var saleDescription = ""
    dynamic var imageURL = ""
    dynamic var startingDate = NSDate()
    dynamic var endingDate = NSDate()
    
    init(address: String, title: String, saleDescription: String, imageURL:String,startingDate:NSDate,endingDate:NSDate) {
        self.address = address
        self.title = title
        self.saleDescription = saleDescription
        self.imageURL = imageURL
        self.startingDate = startingDate
        self.endingDate = endingDate
    }
}
