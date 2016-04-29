//
//  ProfileViewController.swift
//  cleanse
//
//  Created by Stef Epp on 4/21/16.
//  Copyright © 2016 cleanse co. All rights reserved.
//

//TWITTER HW PROF VIEW CONTROLLER

import UIKit
import AFNetworking
class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var descriptLabel: UILabel!
    @IBOutlet weak var FollowersCount: UILabel!
    @IBOutlet weak var FollowingCount: UILabel!
    @IBOutlet weak var TweetCount: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var name: String! = ""
    var i: Int!
    var tweets: [Tweet]!
    var refresh: UIRefreshControl!
    var dataloaded : Bool = false
    var myprofile: NSDictionary = NSDictionary()
    let twitterClient = TwitterClient.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        //manually populate tweets...
        //of course this should be automated when a specific person is clicked
        
        
        
 /*
        twitterClient.homeTimeline( {(tweets:[Tweet]) -> () in
            self.tweets = tweets
            
            self.tableView.reloadData()
            print (tweets)
            },  failure: { (error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
                
        });
*/
        print("running  usertimeline")
        twitterClient.userTimeline(name as! String!,  success: {(tweets:[Tweet]) -> () in
            self.tweets = tweets
            
            self.tableView.reloadData()
            self.dataloaded = true
            //print (tweets)
            },  failure: { (error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
                 self.twitterClient.deauthorize()
                
        });

        
        
        print (User._currentUser)
        print ("profile")
        if User._currentUser != nil{
        var profile = twitterClient.getProfile(User._currentUser!.screenname as! String!, success: {(profile:NSDictionary)->( ) in
            
            self.myprofile = profile
            
            
            
            
            
            }, failure:{(error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
                 self.twitterClient.deauthorize()
                
        })
        }
        print ("manual profile")
        print (name)
        print(name)
        var profile = twitterClient.getProfile(name as! String!, success: {(profile:NSDictionary)->( ) in
            
            self.myprofile = profile
            
            self.FollowersCount.text = "Followers: " + String(self.myprofile["followers_count"]!)
            self.FollowingCount.text = "Following: " + String(self.myprofile["friends_count"]!)
            self.TweetCount.text = "Tweets: " + String(self.myprofile["statuses_count"]!)
            self.nameLabel.text = String(self.myprofile["screen_name"]!)
            self.descriptLabel.text = String(self.myprofile["description"]!)
            
            
            let image_url =  NSURL(string:self.myprofile["profile_image_url_https"] as! String)
            print(self.myprofile["profile_image_url_https"])
            print (image_url)
            let photoRequest = NSURLRequest(URL: image_url!)
            
        
/*
self.headerimage.setImageWithURLRequest(photoRequest2, placeholderImage:nil,
success:{(photoRequest, photoResponse, image) -> Void in

self.headerimage.image = image

}, failure: { (photoRequest, imageResponse, error) -> Void in
// do something for the failure condition
})


*/

            }, failure:{(error:NSError) -> () in
                print("from profie view controller")
                print ("Error: \(error.localizedDescription)")
            self.twitterClient.deauthorize()

        })

               /*
        let tweet = tweets![0]
        name = (tweet.user?.screenname)! as String!
        nameLabel.text = (tweet.user?.name)!
        handleLabel.text = "@\((tweet.user?.screenname)!)"
        TweetCount.text = "\((tweet.user?.tweetsCount)!)"
        FollowersCount.text = "\((tweet.user?.followerCount)!)"
        FollowingCount.text = "\((tweet.user?.followingCount)!)"
        //bannerImage.setImageWithURL((tweet.user?.coverURL!))
        descriptLabel.text = (tweet.user?.description)!
        */
        /*
        nameLabel.text = tweet.user!.name
        retweetedLabel.text = "\(tweet.user!.screenname!) retweeted"
        handleLabel.text = "@\(tweet.user!.screenname!)"
        tweetLabel.text = tweet.text
        profileImage.setImageWithURL(NSURL(string: tweet.user!.profileUrl! as String)!)
        tagline = "untouched"
        retweetsLabel.text = String(tweet.retweetCount!)
        favoritesLabel.text = String(tweet.favoriteCount!)
        timeLabel.text = tweet.timeSince

        */
        
        if (dataloaded){
            print (self.tweets)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        getTweets()

        refresh = UIRefreshControl()
        refresh.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refresh, atIndex: 0)

        tableView.reloadData()
        
        
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTweets() {
        TwitterClient.sharedInstance.userTimeline(name as String!, success: { (tweets:[Tweet]) -> () in
        //TwitterClient.sharedInstance.userTimeline(screenname) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        },  failure: { (error:NSError) -> () in
            print ("Error: \(error.localizedDescription)")
        self.twitterClient.deauthorize()
            //self.dataloaded = false
        })
    }

    func onRefresh() {
        getTweets()
        self.refresh.endRefreshing()
        self.tableView.reloadData()
    }
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      
        return CGFloat(111.0)

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterCellie", forIndexPath: indexPath) as! TwitterCell
        //print (tweets.count)
        
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.tweetUsername.text = tweet.screenname as! String!
        cell.tweetText.text = tweet.text as! String!
        //cell.tweetTime = tweet.tweettime!
        // need to add the above in the Tweet class
        cell.retweetNumber.text = tweet.retweetCount as! String!
        cell.likeNumber.text = tweet.favoriteCount as! String!
        
        //cell.tweet_id = cell.tweet.tweetId
        //cell.tweetLabel.sizeToFit()
        //cell.tweetImage =
        return cell
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
