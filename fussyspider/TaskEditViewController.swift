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
    @IBOutlet weak var reminderDate: UITextField!
    @IBOutlet weak var reminderHidden: UITextField!
    
    let eventStore = EKEventStore()

    @IBAction func editReminderDate(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("reminderDatePickerValueChanged:"), forControlEvents: .ValueChanged)
    }
    
    @IBAction func editReminderHidden(sender: UITextField) {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("reminderHiddenPickerValueChanged:"), forControlEvents: .ValueChanged)
    }
    
    func reminderDatePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        reminderDate.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func reminderHiddenPickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
        reminderHidden.text = dateFormatter.stringFromDate(sender.date)
    }
    
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
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
            
            reminder.calendar = eventStore.defaultCalendarForNewReminders()
            reminder.title = reminderName.text!
            reminder.notes = reminderNotes.text
        
            if let date = dateFormatter.dateFromString(reminderDate.text!) {
                let alarm = EKAlarm(absoluteDate: date)
                reminder.addAlarm(alarm)
            }
            
            if let hidden = dateFormatter.dateFromString(reminderHidden.text!) {
                if let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian) {
                    let components = calendar.components([.NSDayCalendarUnit, .NSMonthCalendarUnit, .NSYearCalendarUnit, .NSHourCalendarUnit, .NSMinuteCalendarUnit], fromDate: hidden)
                    reminder.startDateComponents = components
                }
            }
            
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
