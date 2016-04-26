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