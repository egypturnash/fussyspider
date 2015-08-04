//
//  MainViewController.swift
//  fussymouse
//
//  Created by Evan Ostroski on 7/19/15.
//  Copyright (c) 2015 Evan Ostroski. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var appDelegate: AppDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initAppDelegate()
        appDelegate!.initEventStore()
        appDelegate!.requestEventAccess()
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
    
    func initAppDelegate() {
        if appDelegate == nil {
            appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        }
    }

}
