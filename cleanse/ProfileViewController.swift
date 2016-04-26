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
    
    var name: String = ""
    var i: Int?
    var tweets: [Tweet]?
    var refresh: UIRefreshControl
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tweet = tweets![i!]
        name = (tweet.user?.screenname)!
        nameLabel.text = (tweet.user?.name)!
        handleLabel.text = "@\((tweet.user?.screenname)!)"
        TweetCount.text = "\((tweet.user?.tweetsCount)!)"
        FollowersCount.text = "\((tweet.user?.followerCount)!)"
        FollowingCount.text = "\((tweet.user?.followingCount)!)"
        //bannerImage.setImageWithURL((tweet.user?.coverURL!))
        descriptLabel.text = (tweet.user?.description)!
        
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
        TwitterClient.sharedInstance.userTimeline(screenname) { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }
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
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TwitterCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
        cell.tweet_id = cell.tweet.tweetId
        cell.tweetLabel.sizeToFit()
        
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
