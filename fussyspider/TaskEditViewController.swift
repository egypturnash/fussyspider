//
//  TaskEditViewController.swift
//  fussymouse
//
//  Created by Evan Ostroski on 7/19/15.
//  Copyright (c) 2015 Evan Ostroski. All rights reserved.
//

import UIKit
import EventKit

class TaskEditViewController: UIViewController {
    @IBOutlet weak var reminderName: UITextField!
    @IBOutlet weak var reminderNotes: UITextView!
    @IBOutlet weak var reminderDate: UIDatePicker!

    let eventStore = EKEventStore()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Save selected
        if sender!.tag == 1 {
            let reminder = EKReminder(eventStore: eventStore)
            
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            reminder.title = reminderName.text!
            reminder.notes = reminderNotes.text
            
            let date = reminderDate.date
            let alarm = EKAlarm(absoluteDate: date)
            reminder.addAlarm(alarm)
            
            saveReminder(reminder)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // Save an EKReminder to the eventStore
    func saveReminder(reminder: EKReminder) {
        do {
            try eventStore.saveReminder(reminder, commit: true)
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    // Hide keyboard if user taps background
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        reminderName.endEditing(true)
        reminderNotes.endEditing(true)
    }
}
