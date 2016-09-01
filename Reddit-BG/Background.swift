//
//  Background.swift
//  Reddit-BG
//
//  Created by Robert Wettstädt on 28/07/16.
//  Copyright © 2016 Robert Wettstädt. All rights reserved.
//

import Foundation

class Background {
    var supportPath: String
    var dbPath: String
    var currentImageName: String
    
    init () {
        var paths = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .AllDomainsMask, true)
        var applicationSupportDirectory = paths.first! as NSString!
        self.supportPath = applicationSupportDirectory.stringByAppendingPathComponent("Reddit-BG") + "/"
        
        paths = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)
        applicationSupportDirectory = paths.first! as NSString!
        self.dbPath = applicationSupportDirectory.stringByAppendingPathComponent("Dock/desktoppicture.db")
        
        self.currentImageName = ""
    }
    
    func removeCurrentImage() {
        let fileManager = NSFileManager.defaultManager()
        let extensions = ["jpg", "png", "gif", "tiff"]
        do {
            let files = try fileManager.contentsOfDirectoryAtPath(self.supportPath)
            for file in files {
                let url = NSURL(fileURLWithPath: file)
                
                if let _ = extensions.indexOf(url.pathExtension!) {
                    try fileManager.removeItemAtPath("\(self.supportPath)\(file)")
                }
            }
        } catch {
            print("err")
        }
    }
    
    func save(image: NSData) {
        let fileManager = NSFileManager.defaultManager()
        var isDir: ObjCBool = false
        
        if fileManager.fileExistsAtPath(self.supportPath, isDirectory: &isDir) && isDir {
            image.writeToFile("\(self.supportPath)\(self.currentImageName)", atomically: true)
        } else {
            do {
                try fileManager.createDirectoryAtPath(self.supportPath, withIntermediateDirectories: true, attributes: nil)
                save(image)
            } catch {
                print("could not create dir at path \(self.supportPath)")
            }
        }
    }
    
    func setImageName(post: RedditPost, image: NSData) {
        var id = "\(post.subreddit_id)_\(post.id)_\(String(post.created))"
        
        var c = UInt8();
        image.getBytes(&c, length: 1)
        switch (c) {
            case 0xFF:
                id += ".jpg" //return @"image/jpeg";
                break
            case 0x89:
                id += ".png" //return @"image/png";
                break
            case 0x47:
                id += ".gif" //return @"image/gif";
                break
            case 0x4D:
                id += ".tiff" //return @"image/tiff";
                break
            default:
                id += ".jpg" //return @"image/jpeg";
                break
        }
        
        self.currentImageName = id
    }
    
    func saveToDB() {
        var db: COpaquePointer = nil
        if sqlite3_open(dbPath, &db) == SQLITE_OK  && sqlite3_exec(db, "DELETE FROM data;", nil, nil, nil) == SQLITE_OK {
            for _ in 0...10 {
                sqlite3_exec(db, "INSERT INTO data ('value') VALUES ('\(self.supportPath)\(self.currentImageName)');", nil, nil, nil)
            }
            system("/usr/bin/killall Dock")
        }
        
        let err = String.fromCString(sqlite3_errstr(sqlite3_errcode(db)))
        print(err!)
        
        sqlite3_close(db)
    }
    
    func set(post: RedditPost) {
        removeCurrentImage()
        
        let cmp = NSURLComponents(string: post.source)
        cmp!.scheme = "https"
        print("\(post.source)  #  \(cmp?.URL)")
        
        var image = NSData(contentsOfURL: (cmp?.URL)!)
        
        if image == nil {
            cmp!.scheme = "http"
            image = NSData(contentsOfURL: (cmp?.URL)!)
        }
        
        setImageName(post, image: image!)
        save(image!)
        
        saveToDB()
    }
 
}