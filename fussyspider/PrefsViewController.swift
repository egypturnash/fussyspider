//
//  PrefsViewController.swift
//  fussymouse
//
//  Created by Evan Ostroski on 7/19/15.
//  Copyright (c) 2015 Evan Ostroski. All rights reserved.
//

import UIKit

class PrefsViewController: UIViewController {
  
  let taskFilter = FSTaskFilter.sharedInstance

  @IBOutlet weak var showCompletedSwitch: UISwitch!
  @IBOutlet weak var sortPrioritySwitch: UISwitch!
  
  @IBAction func showCompletedValueChange(sender: AnyObject) {
    taskFilter.showCompleted = showCompletedSwitch.on
  }
  @IBAction func sortPriorityValueChange(sender: AnyObject) {
    taskFilter.sortPriority = sortPrioritySwitch.on
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    showCompletedSwitch.setOn(taskFilter.showCompleted, animated: false)
    sortPrioritySwitch.setOn(taskFilter.sortPriority, animated: false)
    // Do any additional setup after loading the view.
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
