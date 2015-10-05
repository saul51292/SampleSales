//
//  StyleManager.swift
//  SampleSales
//
//  Created by Saul on 10/4/15.
//  Copyright © 2015 Saul. All rights reserved.
//

import UIKit

class StyleManager: NSObject {
    func circleButtonStyling(button:UIButton){
        button.layer.cornerRadius = button.frame.width/2
    }
    
    func largeButtonStyling(button:UIButton){
        button.layer.cornerRadius = 25
    }
    
}

