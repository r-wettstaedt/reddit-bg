//
//  Background.swift
//  Reddit-BG
//
//  Created by Robert Wettstädt on 28/07/16.
//  Copyright © 2016 Robert Wettstädt. All rights reserved.
//

import Foundation
import AppKit

class Background {
    var supportPath: String
    var currentImageName: String
    
    init () {
        let paths = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .AllDomainsMask, true)
        let applicationSupportDirectory = paths.first! as NSString!
        self.supportPath = applicationSupportDirectory.stringByAppendingPathComponent("Reddit-BG") + "/"
        
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
    
    func setImageName(post: [String: AnyObject], image: NSData) {
        var id = ""
        if let _id = post["subreddit_id"] as? String {
            id += "\(_id)_"
        }
        if let _id = post["id"] as? String {
            id += "\(_id)_"
        }
        if let _id = post["created"] as? Int {
            id += String(_id)
        }
        
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
                break
        }
        
        self.currentImageName = id
    }
        
    func set(post: [String : AnyObject]) {
        if let url = post["url"] as? String {
					
					let cmp = NSURLComponents(string: url.stringByReplacingOccurrencesOfString("&amp;", withString: "&"))
					cmp!.scheme = "https"
					print("\(url)  #  \(cmp?.URL)")
					
					var image = NSData(contentsOfURL: (cmp?.URL)!)
            
					if image == nil {
						cmp!.scheme = "http"
						image = NSData(contentsOfURL: (cmp?.URL)!)
					}
						
					removeCurrentImage()  
					setImageName(post, image: image!)
          save(image!)
					updateDesktopWallpaper()
        } else {
					print("did not find url")
        }
     	
    }
	
	func updateDesktopWallpaper() {
		do {
			
			let imgurl = NSURL.fileURLWithPath(self.supportPath + self.currentImageName)
			
			let workspace = NSWorkspace.sharedWorkspace()
			if let screen = NSScreen.mainScreen()  {
				try workspace.setDesktopImageURL(imgurl, forScreen: screen, options: [:])
			}
		} catch {
			print(error)
		}

	}
 
}