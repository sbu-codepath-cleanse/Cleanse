//
//  LoginViewController.swift
//  Cleanse
//
//  Created by Varun Goel on 4/7/16.
//  Copyright © 2016 Varun Goel. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onLoginButton(sender: AnyObject) {
        let twitterClient = TwitterClient.sharedInstance
        
        // Login when button is clicked
        twitterClient.login({ () -> () in
            print ("LOGGED INTO mycleanserapp")
            
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            } ,
            failure:{
                (error:NSError) -> () in
                
                print ("error: \(error.localizedDescription)");
                
        }
        )
        /*
        // this works (this is tested), but moving this into login in Twitter Client for more centralized model for Twitter API
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "3FI0PnleuC43mADE9ZTCMSR70", consumerSecret: "FYxAfY5XIiIAVQYfwWisa0ySKDAViVti84j9HIMCgMzanefvBu")
        
        twitterClient.deauthorize()
        
        twitterClient.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mycleanserapp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("I got token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            print (url)
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error: NSError!) in
                print("error")
        }
        */
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