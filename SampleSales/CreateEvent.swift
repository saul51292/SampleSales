//
//  CreateEvent.swift
//  SampleSales
//
//  Created by Saul on 10/3/15.
//  Copyright © 2015 Saul. All rights reserved.
//

import Foundation
import EventKit
import UIKit


class CreateEvent:NSObject {
    
    func setUpEvent(name:String,button:UIButton){
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            insertEvent(eventStore,name:name,button:button)
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            eventStore.requestAccessToEntityType(.Event, completion: { (granted, anError) -> Void in
                if !granted {
                    print("Access to store not granted")
                }else{
                    self.insertEvent(eventStore,name:name,button:button)
                }
            })
        default:
            print("Case Default")
        }
    }
    
    
    func insertEvent(store: EKEventStore,name:String,button:UIButton) {
        let startDate = NSDate()
        let endDate = startDate.dateByAddingTimeInterval(2 * 60 * 60)
        // Create Event
        let event = EKEvent(eventStore: store)
        event.calendar = store.defaultCalendarForNewEvents
        
        event.title = name
        event.startDate = startDate
        event.endDate = endDate
        
        let alarm:EKAlarm = EKAlarm(relativeOffset: -60)
        event.alarms = [alarm]
        print(event.alarms)
    
        // Save Event in Calendar
        do {
            try! store.saveEvent(event, span: EKSpan.ThisEvent)
            print("success")
            button.setTitle("Added!", forState: .Normal)
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
            button.userInteractionEnabled = false
            
        }
    }
}
