//
//  MainViewController.swift
//  fussymouse
//
//  Created by Evan Ostroski on 7/19/15.
//  Copyright (c) 2015 Evan Ostroski. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var taskTable: UITableView!
  
  let taskStore = FSTaskStore.sharedInstance
  let taskFilter = FSTaskFilter.sharedInstance
  
  var tasks : [FSTask] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tasks = []
    tasks = taskFilter.filterTasks(taskStore.getAllTasks())
    
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
  
  //  MARK: UITableViewDataSource
  
  func tableView(tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return tasks.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("taskRow", forIndexPath: indexPath)
    let row = indexPath.row
    cell.textLabel!.text = tasks[row].task.title
    return cell
  }
}
