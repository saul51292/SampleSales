//
//  SampleSiteCardView.swift
//  SampleSales
//
//  Created by Saul on 10/2/15.
//  Copyright © 2015 Saul. All rights reserved.
//

import UIKit
import MapKit

class SampleSiteCardView: UIViewController {

    @IBOutlet weak var endingLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var saleDescription: UITextView!
    @IBOutlet weak var titleOfSale: UILabel!
    @IBOutlet weak var mainStreet: UILabel!
    @IBOutlet weak var sampleSaleImage: UIImageView!
    var mainColor = UIColor(red: 118/255, green: 87/255, blue: 143/255, alpha: 1.0)
    
    @IBOutlet weak var calButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var directionsButton: UIButton!
    let createEvent = CreateEvent()
    var sampleCard:SampleSaleModel!
    let sampleSaleQuery = SampleSaleQuery()
    let imageDownload = AsyncImageRequest()
    var isApple = true
    var imageURL:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlur()
        setContent()
        styleSampleSaleImage()
        styleCard(mainColor)
        styleCloseButton()
        // Do any additional setup after loading the view.
    }
    

    
    func setContent(){
        titleOfSale.text = sampleCard.title
        let addressArray = sampleSaleQuery.seperateAddress(sampleCard.address)
        mainStreet.text = addressArray[0]
        saleDescription.attributedText = sampleCard.saleDescription.html2AttributedString
        imageURL = sampleCard.imageURL
    }
    
    func addBlur(){
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        self.view.insertSubview(blurView, atIndex: 0)
    }
    
    func styleCloseButton(){
        closeButton.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.8)
        closeButton.layer.cornerRadius = closeButton.frame.width/2
        closeButton.layer.borderColor = UIColor.whiteColor().CGColor
        closeButton.layer.borderWidth = 2
        closeButton.imageEdgeInsets = UIEdgeInsetsMake(14, 12, 10, 12)
    }
    
    func downloadImage(){
        if let checkedUrl = NSURL(string: imageURL) {
            print(imageURL)
            imageDownload.downloadImage(sampleSaleImage, url: checkedUrl)
            sampleSaleImage.clipsToBounds = true
            sampleSaleImage.contentMode = .ScaleAspectFill
            
        }
    }
    
    func styleSampleSaleImage(){
        downloadImage()
        sampleSaleImage.layer.shadowColor = UIColor.grayColor().CGColor;
        sampleSaleImage.layer.shadowOffset = CGSizeMake(0, 7)
        sampleSaleImage.layer.shadowOpacity = 1
        sampleSaleImage.image = UIImage(named: "default.jpg")
        sampleSaleImage.layer.shadowRadius = 5.0
    }

    
    func openMapWithDirections(address:String){
        var escapedString = address.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        if(isApple){
            escapedString = "http://maps.apple.com/?q=\(escapedString!)"
        }else{
            escapedString = "comgooglemaps://?q=\(escapedString!)"
        }
        let url = NSURL(string: escapedString!)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func getDirections(sender: AnyObject) {
        let url = NSURL(string: "comgooglemaps://")
        let canHandle = UIApplication.sharedApplication().canOpenURL(url!)
        if (canHandle) {
            // Google maps installed
            alertForMaps()
        } else {
            // Use Apple maps?
            isApple = true
            self.openMapWithDirections(self.sampleCard.address)
        }

        
        
    }
    
    @IBAction func addToCalPressed(sender: AnyObject) {
        createEvent.setUpEvent(titleOfSale.text!,button:calButton)
    }
    
    
    func alertForMaps(){
        let alert = UIAlertController(title: "Open Directions?", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        let googleMaps = UIAlertAction(title: "Google Maps", style: .Default) { (action) -> Void in
            self.isApple = false
            self.openMapWithDirections(self.sampleCard.address)
        }
        let appleMaps = UIAlertAction(title: "Apple Maps", style: .Default) { (action) -> Void in
            self.isApple = true
            self.openMapWithDirections(self.sampleCard.address)
        }
        alert.addAction(googleMaps)
        alert.addAction(appleMaps)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
   
    
    func styleCard(color:UIColor){
        separator.backgroundColor = color
        mainStreet.textColor = color
        shareButton.setTitleColor(color, forState: .Normal)
        calButton.setTitleColor(color, forState: .Normal)
        directionsButton.setTitleColor(color, forState: .Normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}

extension String {
    var html2AttributedString:NSAttributedString {
        return try! NSAttributedString(data: dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil)
    }
}

