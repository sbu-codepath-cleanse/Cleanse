//
//  User.swift
//

import UIKit

class User: NSObject {
    static let userDidLogoutNotification = "UserDidLogout"
    
    var name: String?
    var screenname: String?
    var coverURL: NSURL?
    var tagline: NSString?
    var tweetsCount : NSString?
    var followingCount : NSString?
    var followerCount : NSString?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        print (screenname)
        tagline = dictionary["description"] as? String
        tweetsCount = "tweet_count"
        followingCount = "following_count"
        followerCount = "follower_count"
        
        let profileImageUrl = dictionary["profile_image_url_https"] as? String
        
        if let profileImageUrl = profileImageUrl{
            coverURL  = NSURL(string: profileImageUrl)
        }
    }
    
    static var _currentUser: User?
    
    class var currentUser: User?{
        get{
            if _currentUser == nil{
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData{
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        }
        
        set(user){
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user{
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options:  [])
                
                defaults.setObject(data , forKey: "currentUserData")
            }
            else{
                defaults.setObject(nil , forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}