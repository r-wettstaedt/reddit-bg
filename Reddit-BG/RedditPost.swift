//
//  RedditParser.swift
//  Reddit-BG
//
//  Created by Robert Wettstädt on 04/08/16.
//  Copyright © 2016 Robert Wettstädt. All rights reserved.
//

import Foundation

class RedditPost {

    var width: Int
    var height: Int

    var source: String
    var isSelf: Bool

    var preview: String
    var score: Int
    var title: String
    var subreddit: String
    var created: Int
    var author: String
    var permalink: String

    init() {
        self.width = 0
        self.height = 0

        self.source = ""
        self.isSelf = false

        self.preview = ""
        self.score = 0
        self.title = ""
        self.subreddit = ""
        self.created = 0
        self.author = ""
        self.permalink = ""
    }

    func setWithPost(post: [String: AnyObject]) {
        if let preview = post["preview"] as? [String:AnyObject] {
            if let images = preview["images"] as? [[String:AnyObject]] {
                if let source = images[0]["source"] as? [String:AnyObject] {
                    if let width = source["width"] as? Int {
                        self.width = width
                    }
                    if let height = source["height"] as? Int {
                        self.height = height
                    }
                    if let url = source["url"] as? String {
                        self.source = url.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
                    }
                }

                if let resolutions = images[0]["resolutions"] as? [[String:AnyObject]] {
                    if let url = resolutions[2]["url"] as? String {
                        self.preview = url.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
                    }
                }
            }
        }

        if let score = post["score"] as? Int {
            self.score = score
        }

        if let isSelf = post["is_self"] as? Bool {
            self.isSelf = isSelf
        }

        if let title = post["title"] as? String {
            self.title = title
        }
        
        if let subreddit = post["subreddit"] as? String {
            self.subreddit = "/r/\(subreddit)"
        }

        if let created = post["created"] as? Int {
            self.created = created
        }

        if let author = post["author"] as? String {
            self.author = author
        }

        if let permalink = post["permalink"] as? String {
            self.permalink = "https://reddit.com\(permalink)"
        }
    }

}