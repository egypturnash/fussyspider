//
//  MainViewController.swift
//  fussymouse
//
//  Created by Evan Ostroski on 7/19/15.
//  Copyright (c) 2015 Evan Ostroski. All rights reserved.
//

import UIKit
import EventKit


// Error started after deleting IBOutlet to table
// Need to research how to manage a table in a View Controller
// Possibly just embedded a TableViewController in a Navigation Controller, but what about bottom buttons?
// Maybe just simplify the interface by having a dedicated controller for just the table, separate of the MainViewController
class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var taskTable: UITableView!
    
    var reminders: [EKReminder] = []
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return reminders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taskRow", forIndexPath: indexPath)
        let row = indexPath.row
        
        cell.textLabel!.text = reminders[row].title
        
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.taskTable.delegate = self
        self.taskTable.dataSource = self
        let delegate = UIApplication.sharedApplication().delegate as? AppDelegate    
        reminders = (delegate?.reminders)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
