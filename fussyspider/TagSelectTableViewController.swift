//
//  TagSelectTableViewController.swift
//  fussymouse
//
//  Created by Evan Ostroski on 7/19/15.
//  Copyright (c) 2015 Evan Ostroski. All rights reserved.
//

import UIKit

class TagSelectTableViewController: UITableViewController {
  
  let taskFilter = FSTaskFilter.sharedInstance
  let tagStore = FSTagStore.sharedInstance
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tagStore.loadAllTags()
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: UITableViewDataSource protocol functions
  
  // required
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tagStore.count + 1
  }
  
  // required
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("tagRow", forIndexPath: indexPath)
    let row = indexPath.row
    
    if row == 0 {
      cell.textLabel!.text = "Show All"
      if taskFilter.showAll {
        cell.accessoryType = .Checkmark
      }
    } else {
      if let tag = tagStore.getTagAtIndex(row-1) {
        let taskFilter = FSTaskFilter.sharedInstance
        if taskFilter.tags.contains(tag) {
          cell.accessoryType = .Checkmark
        }
        cell.textLabel!.text = tag.title
      }
    }
    return cell
  }
  
  // MARK: UITableViewDelegate protocol functions
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    toggleCell(tableView, indexPath: indexPath)
  }
  
  func toggleCell(tableView: UITableView, indexPath: NSIndexPath) {
    if let cell = tableView.cellForRowAtIndexPath(indexPath) {
      // SELECT ALL
      if indexPath.row == 0 {
        if taskFilter.showAll {
          taskFilter.showAll = false
          cell.accessoryType = .None
        } else {
          clearCheckmarks()
          taskFilter.showAll = true
          cell.accessoryType = .Checkmark
        }
        return
      }
      if let tag = tagStore.getTagWithTitle(cell.textLabel!.text!) {
        if taskFilter.showAll {
          toggleCell(tableView, indexPath: NSIndexPath(forRow: 0, inSection: 0))
        }
        if !taskFilter.tags.contains(tag) {
          cell.accessoryType = .Checkmark
          taskFilter.tags.append(tag)
        } else {
          cell.accessoryType = .None
          taskFilter.tags.removeAtIndex(taskFilter.tags.indexOf(tag)!)
        }
      }
    }
  }
  
  func clearCheckmarks () {
    for filterTag in taskFilter.tags {
      if let tag = tagStore.getTagWithTitle(filterTag.title!) {
        if let row = tagStore.getIndexOfTag(tag) {
          toggleCell(tableView, indexPath: NSIndexPath(forRow: row+1, inSection: 0))
        }
      }
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
  /*
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 
  }
  */
}
