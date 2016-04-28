//
//  ProfileViewController.swift
//  cleanse
//
//  Created by Stef Epp on 4/21/16.
//  Copyright © 2016 cleanse co. All rights reserved.
//

//TWITTER HW PROF VIEW CONTROLLER

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //manually populate tweets...
        //of course this should be automated when a specific person is clicked
        let twitterClient = TwitterClient.sharedInstance
        
        
        /*
        twitterClient.homeTimeline( {(tweets:[Tweet]) -> () in
            self.tweets = tweets
            
            self.tableView.reloadData()
            print (tweets)
            },  failure: { (error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
                
        });
        
        */
        twitterClient.userTimeline("NBCTheVoice",  success: {(tweets:[Tweet]) -> () in
            self.tweets = tweets
            
            self.tableView.reloadData()
            //print (tweets)
            },  failure: { (error:NSError) -> () in
                print ("Error: \(error.localizedDescription)")
                
        });
    

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
        
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        getTweets()

        refresh = UIRefreshControl()
        refresh.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refresh, atIndex: 0)

        
        
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
            //self.dataloaded = false
        })
    }

    func onRefresh() {
        getTweets()
        self.refresh.endRefreshing()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        }
        else {
            return 0
        }
    }
    
    //I'm not sure this is necessary?
    /*


@IBOutlet weak var tweetImage: UIImageView!
@IBOutlet weak var tweetUser: UILabel!
@IBOutlet weak var tweetUsername: UILabel!
@IBOutlet weak var tweetText: UILabel!
@IBOutlet weak var tweetTime: UILabel!
@IBOutlet weak var retweetNumber: UILabel!
@IBOutlet weak var likeNumber: UILabel!
*/
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterCellie", forIndexPath: indexPath) as! TwitterCell
        //print (tweets.count)
        let tweet = tweets[indexPath.row]
        cell.tweet = tweets![indexPath.row]
       // cell.tweetUsername.text = tweet.screenname!
        cell.tweetText.text = tweet.text!
        //cell.tweetTime = tweet.tweettime!
        // need to add the above in the Tweet class
        cell.retweetNumber.text = tweet.retweetCount!
        cell.likeNumber.text = tweet.favoriteCount!
        
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
