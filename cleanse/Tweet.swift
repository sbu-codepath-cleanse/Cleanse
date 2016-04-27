//
//  Tweet.swift
//  cleanse
//
//  Created by Lise Ho on 4/26/16.
//  Copyright © 2016 cleanse co. All rights reserved.
//

import UIKit

class Tweet: NSObject {

        var tweetId: String?
        var user: User?
        var text: String?
        var createdAtString: String?
        var createdAt: NSDate?
        var screenname: String?
        var replyToScreename: String?
        
        var retweetCount: String?
        var favoriteCount: String?
        
        init(dictionary: NSDictionary) {
            tweetId = (dictionary["id_str"] as! String?)!
            user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
            text = dictionary["text"] as? String
            createdAtString = dictionary["created_at"] as? String
            screenname = dictionary["screenname"] as? String
            replyToScreename = dictionary["in_reply_to_screen_name"] as? String
            
            retweetCount = "\((dictionary["retweet_count"])!)"
            favoriteCount = "\((dictionary["favorite_count"])!)"
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.dateFromString(createdAtString!)
        }
        
        class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
            var tweets = [Tweet]()
            
            for dictionary in array {
                tweets.append(Tweet(dictionary: dictionary))
            }
            
            return tweets
        }
    
}
