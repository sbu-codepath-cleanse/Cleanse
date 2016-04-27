<<<<<<< HEAD
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
=======
import UIKit

class Tweet: NSObject {
    
    var user: User?
    
    var text:  String?
    var ID: NSNumber?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    
    
    init(dictionary: NSDictionary){
        text = dictionary["text"] as? String
        
        user = User(dictionary: (dictionary["user"] as? NSDictionary)!)
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        favoritesCount = (dictionary["favorites_count"] as? Int) ?? 0
        
        ID = dictionary["id"] as? Int
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
        
    }
    
    class func tweetsWithArray(dictionaies: [NSDictionary]) -> [Tweet]{
        var  tweets = [Tweet]()
        
        for dictionary in dictionaies{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
    //return a s tweet as a dictionary form for easier parsing
    class func tweetAsDictionary(dict: NSDictionary) -> Tweet {
        return Tweet(dictionary: dict)
    }
    
}
>>>>>>> 28386f811bb0cc901570f10061e0d976e8199a25
