//
//  MainViewController.swift
//  fussymouse
//
//  Created by Evan Ostroski on 7/19/15.
//  Copyright (c) 2015 Evan Ostroski. All rights reserved.
//

import UIKit


// Error started after deleting IBOutlet to table
// Need to research how to manage a table in a View Controller
// Possibly just embedded a TableViewController in a Navigation Controller, but what about bottom buttons?
// Maybe just simplify the interface by having a dedicated controller for just the table, separate of the MainViewController
class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var taskTable: UITableView!
    
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tagFilter = delegate.tagFilter
        
        checkAuthorizationStatus(authorized: {
            fetchReminders(tagFilter, completion: {
                self.taskTable.reloadData()
            })
        })        
        
        // The UITableView needs to know where to send events and get data
        self.taskTable.delegate = self
        self.taskTable.dataSource = self
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
    
    //
    //  UITableViewDataSource protocol functions
    //
    //
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return delegate.fussyReminders.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taskRow", forIndexPath: indexPath)
        let row = indexPath.row
        
        cell.textLabel!.text = delegate.fussyReminders[row].reminder.title
        
        return cell
    }
}
