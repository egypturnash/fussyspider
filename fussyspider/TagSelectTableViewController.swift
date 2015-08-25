//
//  TagSelectTableViewController.swift
//  fussymouse
//
//  Created by Evan Ostroski on 7/19/15.
//  Copyright (c) 2015 Evan Ostroski. All rights reserved.
//

import UIKit

class TagSelectTableViewController: UITableViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            return delegate.fussyTags.count + 1
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tagRow", forIndexPath: indexPath)
        let row = indexPath.row
        
        if row == 0 {
            cell.textLabel!.text = "Toggle All"
        } else {
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate {
                let tagName = delegate.fussyTags[row-1].name
                let tagFilter = delegate.tagFilter
                
                if tagFilter.contains(tagName) {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
                cell.textLabel!.text = delegate.fussyTags[row-1].name
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        toggleCell(tableView, indexPath: indexPath)
    }
    
    func toggleCell(tableView: UITableView, indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let tagName = cell.textLabel!.text!
            let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            var tagFilter = delegate!.tagFilter
            
            // SELECT ALL
            if indexPath.row == 0 {
                tagFilter = []
                for index in 1...(tableView.numberOfRowsInSection(0)) {
                    toggleCell(tableView, indexPath: NSIndexPath(forRow: index, inSection: 0))
                }
                return
            }
            
            if !tagFilter.contains(tagName) {
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
                tagFilter.append(tagName)
            } else {
                tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
                tagFilter.removeAtIndex(tagFilter.indexOf(tagName)!)
            }
            
            delegate!.tagFilter = tagFilter
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Save selected
        if sender!.tag == 1 {
            // TODO Look at selected rows and update appDelegate
        }
    }

}
