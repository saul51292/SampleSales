//
//  ViewController.swift
//  SampleSales
//
//  Created by Saul on 10/2/15.
//  Copyright © 2015 Saul. All rights reserved.
//

import UIKit
import MapKit
import Parse

class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var dayButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    let kDistanceMeters:CLLocationDistance = 500
    var sampleCard:SampleSaleModel!
    let styleManager = StyleManager()
    var sampleSaleQuery = SampleSaleQuery()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
            
        let location = CLLocationCoordinate2D(
            latitude: 40.748441,
            longitude: -73.985664
        )
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)

        locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() == .NotDetermined) {
            locationManager.requestWhenInUseAuthorization()
            print("Requesting Authorization")
        } else {
            locationManager.startUpdatingLocation()
        }
        
        sampleSaleQuery.getListOfSales(mapView)
        
        //sampleSaleQuery.getJson()
        styleManager.largeButtonStyling(timeButton)
        styleManager.largeButtonStyling(dayButton)
        styleManager.circleButtonStyling(locationButton)
        styleManager.circleButtonStyling(listButton)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if (status != .NotDetermined) {
            mapView.showsUserLocation = true
        } else {
            print("Authorization to use location data denied")
        }
    }

    func mapView(mapView: MKMapView,viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation{
                return nil
            }
            
            let reuseId = "pin"
            
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            
            if(pinView == nil){
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.pinTintColor = UIColor.redColor()
                
                let calloutButton = UIButton(type: .DetailDisclosure) as UIButton
                pinView!.rightCalloutAccessoryView = calloutButton
            } else {
                pinView!.annotation = annotation
            }
            return pinView!
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            let annotationClicked = annotationView.annotation as! SampleSaleAnnotation
            sampleCard = annotationClicked.sampleSale
            performSegueWithIdentifier("goToCard", sender: self)
        }
    }
    
    @IBAction func clickedLocation(sender: AnyObject) {
        centerToUsersLocation()
    }
    
    @IBAction func timeButtonClicked(sender: UIButton) {
        switch(sender.titleLabel!.text!){
            case "Ongoing":
                sender.setTitle("Starting", forState: .Normal)
            case "Starting":
                sender.setTitle("Ending", forState: .Normal)
            case "Ending":
                sender.setTitle("Ongoing", forState: .Normal)
        default:
            print("error")
            break
        }
    }
    
    func centerToUsersLocation() {
        let center = mapView.userLocation.coordinate
        let zoomRegion : MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(center, kDistanceMeters, kDistanceMeters)
        mapView.setRegion(zoomRegion, animated: true);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToCard"){
            let vc = segue.destinationViewController as! SampleSiteCardView
            vc.sampleCard = sampleCard
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}


