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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            let reminder = EKReminder(eventStore: delegate!.eventStore!)
            
            reminder.calendar = delegate!.eventStore!.defaultCalendarForNewReminders()
            reminder.title = reminderName.text!
            reminder.notes = reminderNotes.text
            
            let date = reminderDate.date
            let alarm = EKAlarm(absoluteDate: date)
            reminder.addAlarm(alarm)
            
            delegate!.saveReminder(reminder)
            delegate!.fetchReminders()
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
