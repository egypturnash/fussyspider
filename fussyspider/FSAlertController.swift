//
//  FSAlertController.swift
//  fussyspider
//
//  Created by Evan Ostroski on 9/4/15.
//  Copyright © 2015 Egypt Urnash. All rights reserved.
//

import UIKit

class FSAlertController: UIAlertController {

    override func viewWillAppear(animated: Bool) {
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (action) -> Void in
            print("Alert closed")
        }
        self.addAction(okAction)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func simpleAlert() {
        
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
