import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    
    //creating the request thing
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "3FI0PnleuC43mADE9ZTCMSR70", consumerSecret: "FYxAfY5XIiIAVQYfwWisa0ySKDAViVti84j9HIMCgMzanefvBu")
    
    // static var sharedInstance =  TwitterClient(baseURL: NSURL(string:"https://api.twitter.com")!, consumerKey: "SXqFBvQ0ibQxJLzANwYYF1jcN", consumerSecret: "7Dz4eSTJumYpYnPWdgKitBN60OTFgREsp6OdiNY6C3ihT1OS2l")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) ->  ())?
    
    //login function
    func login(success: () ->(), failure: (NSError) -> () ){
        loginSuccess = success
        loginFailure = failure
        
        //log out first
        TwitterClient.sharedInstance.deauthorize()
        //User._currentUser = nil
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mycleanserapp://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            
            //open the URL
            UIApplication.sharedApplication().openURL(url)
            
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure!(error)
        }
    }
    
    //when the user wants to logout
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    //function for opening the URL
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!)
            -> Void in
            
            self.currentAcount({ (user: User) -> () in
                User.currentUser = user
                print ("gah")
                print (User.currentUser)
                self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
        }) { (error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    //declaring the closure
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> () ){
        //calling the closure
        //GETTING THE USER'S HOME TIMELINE
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (NSURLSessionDataTask,response: AnyObject?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            }, failure: { (NSURLSessionDataTask,error: NSError) -> Void in
                failure(error)
        })
    }
    
    //declaring the closure for other user's timeline
    func userTimeline(screenname:String, success: ([Tweet]) -> (), failure: (NSError) -> () ){
        //calling the closure
        //GETTING THE USER'S TIMELINE
        //GET("1.1/statuses/user_timeline.json?screen_name=\(screenname)", parameters: nil, success: { (NSURLSessionDataTask,response: AnyObject?) -> Void in
        let param = ["screen_name":screenname as! String!]
        GET("1.1/statuses/user_timeline.json", parameters: param,success: {(NSURLSessionDataTask, response:AnyObject?)-> Void in
            let dictionaries = response as! [NSDictionary]
            //print (response)
            let tweets = Tweet.tweetsWithArray(dictionaries)

            //let tweets = [] as! [Tweet]
            success(tweets)
            }, failure: { (NSURLSessionDataTask,error: NSError) -> Void in
                print (error.localizedDescription)
                failure(error)
        })
    }
    
    
    func getProfile (screenname:String, success: NSDictionary-> (), failure:NSError -> () ){
        
        let params = ["screen_name": screenname]
        
        GET("1.1/users/show.json",parameters: params,progress: nil,success: {(task:NSURLSessionDataTask, response:AnyObject?)-> Void in
            print (response)
            let tweetdictionaries = response as! NSDictionary
            
            success(tweetdictionaries)
            
            },failure:{(task:NSURLSessionDataTask?,error:NSError )-> Void in
                print("error in getProfile")
                print (error.localizedDescription)
                failure(error)
                
        });
        //print (tweetdictionaries)
        
    }
     
     func currentAcount(success: (User) -> (), failure: (NSError) -> ()){
     //VERIFYING THE CREDENTIALS AND GETTING THE USER'S NAME AND STUFF
     GET("1.1/account/verify_credentials.json", parameters: nil, success: { (NSURLSessionDataTask,response: AnyObject?) -> Void in
        let userDictionary = response as! NSDictionary
        let user = User(dictionary: userDictionary)
     
     success(user)
     
     }, failure: { (NSURLSessionDataTask,error: NSError) -> Void in
        failure(error)
     })
    }

    //when the user wants to retweet, this function is called
    func retweetTweet(params: NSDictionary?, completion: (tweets: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(params!["id"] as! Int).json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            completion(tweets: tweet, error: nil)
            
        }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print("ERROR: \(error)")
            completion(tweets: nil, error: error)
        }
    }
    
    //when the user wants to retweet, this function is called
    func likeTweet(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            
            completion(tweet: tweet, error: nil)
            
        }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print("ERROR: \(error)")
            completion(tweet: nil, error: error)
        }
    }
    
    //function for replying on a tweet
    func reply(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/statuses/update.json?status=\(params!["tweet"]!)&in_reply_to_status_id=\(params!["id"] as! Int).json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
        }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            completion(tweet: nil, error: error)
        }
        
    }
    
    //function to create a new tweet
    func create(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        
        POST("1.1/statuses/update.json?status=\(params!["tweet"]!)", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            let tweet = Tweet.tweetAsDictionary(response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
        }) { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            completion(tweet: nil, error: error)
        }
        
    }
    func getFriends(screenname:String, success: NSArray-> (), failure:NSError -> ()){
        // workes when not alot of requests have been made
        
        let params = ["screen_name":"twitterapi" as! String!]
        print (screenname)
        GET("1.1/friends/ids.json", parameters: params, success: { (NSURLSessionDataTask,response: AnyObject?) -> Void in
        
            
            let responsed = response as! NSDictionary
            print ("my friends")
            //print (tweetdictionaries)
            print (responsed["ids"] as! NSArray)
            
            let tweetdictionaries = responsed["ids"] as!  NSArray
            success(tweetdictionaries)
            
            },failure:{(task:NSURLSessionDataTask?,error:NSError )-> Void in
                print (error.localizedDescription)
                failure(error)
                
        });
    }
    
    
    func destroy_unfollow(screenname:String, success: NSDictionary -> (), failure: NSError -> ()){
        let params = ["screen_name":screenname]
        
        POST("1.1/friendships/destroy.json", parameters: params, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print("destroying a friendship")
            let cleansed = (response as! NSDictionary)
            
            print(cleansed)
            success(cleansed)
            
            
            }, failure:{(task:NSURLSessionDataTask?,error:NSError )-> Void in
                print (error.localizedDescription)
                failure(error)
        });
        
        
    }
    
    
    
}
