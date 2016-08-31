//
//  RedditFetcher.swift
//  Reddit-BG
//
//  Created by Robert Wettstädt on 21/07/16.
//  Copyright © 2016 Robert Wettstädt. All rights reserved.
//

import Foundation

class RedditFetcher {

    let LIMIT = 10
    var post: RedditPost

    init(post: RedditPost) {
        self.post = post
    }

    func fetch(subreddits subreddits: [String], callback: (post: [String:AnyObject]?) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            var posts: [[String:AnyObject]] = []
            
            for subreddit in subreddits {
                let url = NSURL(string: "https://www.reddit.com/r/\(subreddit).json?limit=\(self.LIMIT)")
                let chunk = NSData(contentsOfURL: url!)
                var json: [String:AnyObject] = [:]
                
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(chunk!, options: []) as! [String:AnyObject]
                } catch {
                    print("erro")
                }
                
                if let data = json["data"] as? [String:AnyObject] {
                    if let children = data["children"] as? [[String:AnyObject]] {
                        for child in children {
                            if let post = child["data"] as? [String:AnyObject]{
                                posts.append(post)
                            }
                        }
                    }
                }
            }
            
            let post = self.getRandom(posts)
            
            dispatch_async(dispatch_get_main_queue()) {
                callback(post: post)
            }
        }
    }

    func getRandom(posts: [[String:AnyObject]]) -> [String:AnyObject]? {
        if (posts.count == 0) { return nil }

        while true {
            let rng = Int(arc4random()) % posts.count
            self.post.setWithPost(posts[rng])

            if self.post.width > self.post.height && self.post.height > 1080 && !self.post.isSelf {
                return posts[rng]
            }
        }
    }

}