//
//  SampleSaleQuery.swift
//  SampleSales
//
//  Created by Saul on 10/4/15.
//  Copyright © 2015 Saul. All rights reserved.
//

import UIKit
import MapKit
import Parse

class SampleSaleQuery: NSObject {
    
    
    func getListOfSales(mapView:MKMapView){
        PFGeoPoint.geoPointForCurrentLocationInBackground { (point, error) -> Void in
            if error == nil {
                //Point contains the user's current point
                
                //Get a max of 100 of the restaurants that are within 5km,
                //ordered from nearest to furthest
                let query = PFQuery(className: "SampleSale")
                query.limit = 100
                query.whereKey("saleLocation", nearGeoPoint: point!, withinKilometers: 100.0)
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    if (error == nil) {
                        //objects contains the restaurants
                        for object in objects! {
                            let descLocation = object["saleLocation"] as! PFGeoPoint
                            let latitude: CLLocationDegrees = descLocation.latitude
                            let longtitude: CLLocationDegrees = descLocation.longitude
                            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                            self.createPin(mapView,title: object["title"] as! String,address: object["address"] as! String, description: object["saleDescription"] as! String, imageURL:object["imageURL"] as! String, location:location)
                        }
                    }else{
                        print(error!.description)
                    }
                })
            }else{
                print(error!.description)
            }
        }
    }
    
    func convertAddressToGeocode(address:String,sampleCard:SampleSaleModel){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) -> Void in
            if let placemark = placemarks?.first {
                self.saveLocation(placemark.location!,sampleCard:sampleCard)
            }
        }
    }
    
    func dateFromString(dateString:String)->NSDate{
        let dateFormatter = NSDateFormatter()
        // this is imporant - we set our input date format to match our input string
        dateFormatter.dateFormat = "MM/dd/yyyy"
        // voila!
        return dateFormatter.dateFromString(dateString)!
    }
    
    func getJson(){
        let masterDataUrl: NSURL = NSBundle.mainBundle().URLForResource("sampleSale", withExtension: "json")!
        let jsonData: NSData = NSData(contentsOfURL: masterDataUrl)!
        let jsonResult: NSDictionary = try! NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
        let sales : NSArray = jsonResult["sales"] as! NSArray
        for sale in sales as [AnyObject]{
            let address = sale["address"]! as! String
            let title = sale["title"]! as! String
            let imageURL = sale["imageURL"] as! String
            let saleDesc = sale["saleDescription"] as! String
            let startingDate = dateFromString(sale["startDate"] as! String)
            let endingDate = dateFromString(sale["endDate"] as! String)
            createSampleObject(address, title: title, saleDesc: saleDesc, imageURL: imageURL, startingDate: startingDate, endingDate: endingDate)
        }
    }
    
    func createSampleObject(address:String,title:String,saleDesc:String,imageURL:String,startingDate:NSDate,endingDate:NSDate){
        
        let newSample =  SampleSaleModel(
            address: address,
            title: title,
            saleDescription: saleDesc,
            imageURL: imageURL,
            startingDate: startingDate,
            endingDate: endingDate)
        convertAddressToGeocode(newSample.address,sampleCard:newSample)
    }
    
    func saveLocation(location:CLLocation,sampleCard:SampleSaleModel){
        let sampleSale = PFObject(className: "SampleSale")
        sampleSale["address"] = sampleCard.address
        sampleSale["title"] = sampleCard.title
        sampleSale["imageURL"] = sampleCard.imageURL
        sampleSale["saleDescription"] = sampleCard.saleDescription
        sampleSale["startingDate"] = sampleCard.startingDate
        sampleSale["endingDate"] = sampleCard.endingDate
        let point = PFGeoPoint(location: location)
        sampleSale["saleLocation"] = point
        sampleSale.saveInBackgroundWithBlock { (success, error) -> Void in
            print("Object has been saved.")
        }
    }

    
    func seperateAddress(addressString:String)->[String]{
        let addressArray = addressString.characters.split { $0 == "," }.map { String($0) }
        return addressArray
    }
    
    func createPin(mapView:MKMapView,title:String,address:String, description:String, imageURL:String,location:CLLocationCoordinate2D){
        let addressArray = seperateAddress(address)
        let sample = SampleSaleModel(address: address, title: title, saleDescription: description, imageURL: imageURL, startingDate: NSDate(), endingDate: NSDate())
        let annotation = SampleSaleAnnotation(coordinate: location, title: title, subtitle: addressArray[1], sampleSale: sample)
        mapView.addAnnotation(annotation)
    }
}

