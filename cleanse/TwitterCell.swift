//
//  TwitterCell.swift
//  cleanse
//
//  Created by Tim Barnard on 4/12/16.
//  Copyright © 2016 cleanse co. All rights reserved.
//

import UIKit

class TwitterCell: UITableViewCell {

    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var tweetUser: UILabel!
    @IBOutlet weak var tweetUsername: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tweetTime: UILabel!
    @IBOutlet weak var retweetNumber: UILabel!
    @IBOutlet weak var likeNumber: UILabel!
    
    var tweet: Tweet! {
        didSet {
            
            nameLabel.text = tweet.user!.name
            retweetedLabel.text = "\(tweet.user!.screenname!) retweeted"
            handleLabel.text = "@\(tweet.user!.screenname!)"
            tweetLabel.text = tweet.text
            profileImage.setImageWithURL(NSURL(string: tweet.user!.profileUrl! as String)!)
            
            retweetsLabel.text = String(tweet.retweetCount!)
            favoritesLabel.text = String(tweet.favoriteCount!)
            timeLabel.text = tweet.timeSince
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
