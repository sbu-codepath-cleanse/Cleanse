//
//  ViewController.swift
//  cleanse
//
//  Created by Tim Barnard on 3/22/16.
//  Copyright © 2016 cleanse co. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var myfriends: NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let twitterClient = TwitterClient.sharedInstance
        let following = twitterClient.getFriends("AmericanIdol" as! String!, success: {(profile:NSArray)->( ) in
            
            self.myfriends = profile
            
            print("/hurere")
            }, failure:{(error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
                
        })
        print (myfriends)
        print("slkdfjkldsj")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

