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
    var unfollower : NSDictionary = [:]
    
    @IBOutlet weak var ProfileView: UIImageView!
    
    @IBOutlet weak var screenname: UILabel!
    @IBOutlet weak var dislikebutton: UIImageView!
    
    @IBOutlet weak var likebutton: UIImageView!
    let twitterClient = TwitterClient.sharedInstance
    
    var userarray :[String] = ["WomenTechmakers", "NBCTheVoice", "edutopia"]
    var number = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print (userarray[number])
        var profile = twitterClient.getProfile(userarray[number] as! String!, success: {(profile:NSDictionary)->( ) in
            

            self.screenname.text = String(profile["screen_name"]!)
            let image_url =  NSURL(string:profile["profile_image_url_https"] as! String)
            let photoRequest = NSURLRequest(URL: image_url!)
            /*
            self.ProfileView.setImageWithURLRequest(photoRequest, placeholderImage:nil,
                success:{(photoRequest, photoResponse, image) -> Void in
                    self.image_tweet.image = image
                }, failure: { (photoRequest, imageResponse, error) -> Void in
                    // do something for the failure condition
            })
            */
            },
            failure:{(error:NSError) -> () in
        print("from profie view controller")
        print ("Error: \(error.localizedDescription)")
    
        })
        let tapGesture = UITapGestureRecognizer(target: self, action: "dislike:")
        // add it to the image view;
        dislikebutton.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        dislikebutton.userInteractionEnabled = true
        
        
        let tapGestured = UITapGestureRecognizer(target: self, action: "like:")
        
        // add it to the image view;
        likebutton.addGestureRecognizer(tapGestured)
        // make sure imageView can be interacted with by user
        likebutton.userInteractionEnabled = true

        

  /*
twitterClient.getFriends("lise__ho" as! String!, success: {(profile:NSArray)->( ) in
            
            self.myfriends = profile
            
            }, failure:{(error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
                
        })
        print (myfriends)
        print("slkdfjkldsj")

    }
    */
    
    func like(gesture: UIGestureRecognizer) {
    
        print ("yay")
        
    }
    func dislike(gesture: UIGestureRecognizer) {
        //2362618909
        var x : String = userarray[number] as! String!
        let unfollowed = self.twitterClient.destroy_unfollow(x, success:{(cleansed: NSDictionary) -> () in
            
            
            let unfollower = cleansed
            print (unfollower)
            },failure: { (error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
            }
            
        )

        print ("nay")
        
    }
    func next(){
        
        
    }
    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let elementViewController = segue.destinationViewController as! ProfileViewController

       elementViewController.name = self.screenname.text
        
        
            // Get the new view controller using segue.destinationViewController.
            // Pass the selected object to the new view controller.
        }
    }


}

