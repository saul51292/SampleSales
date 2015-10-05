//
//  AsyncImageRequest.swift
//  SampleSales
//
//  Created by Saul on 10/5/15.
//  Copyright © 2015 Saul. All rights reserved.
//

import UIKit

class AsyncImageRequest: NSObject {
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: data)
            }.resume()
    }
    
    func downloadImage(imageView:UIImageView,url:NSURL){
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = UIImage(data: data!)
            }
        }
    }

}
