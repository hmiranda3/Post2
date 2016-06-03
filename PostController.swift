//
//  PostController.swift
//  Post2
//
//  Created by Habib Miranda on 6/2/16.
//  Copyright © 2016 littleJohns. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseURL = NSURL(string: "https://devmtn-post.firebaseio.com")
    
    static let endpoint = baseURL?.URLByAppendingPathComponent("/posts.json")
    
    weak var delegate: PostControllerDelegate?
    
    var posts: [Post] = [] {
        didSet {
            delegate?.postsUpdated(posts)
        }
    }

    
    func fetchPosts(reset reset: Bool = true, completion: ((newPosts: [Post]) -> Void)? = nil) {
        guard let unwrappedURL = PostController.endpoint else {
            fatalError("Endpoint failed!")
        }
        
        let queryEndInterval = reset ? NSDate().timeIntervalSince1970 : posts.last?.queryTimestamp ?? NSDate().timeIntervalSince1970

        
        let urlParameters = [
            "orderBy": "\"timestamp\"",
            "endAt": "\(queryEndInterval)",
            "limitToLast": "15",
            ]

        NetworkController.performRequestForURL(unwrappedURL, httpMethod: .Get, urlParameters: urlParameters) { (data, error) in
            
            let responseData = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            guard let data = data,
                let jsonDictionaries = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? [String: [String: AnyObject]] else {
                    
                    print("Unable to serialize JSON. \nResponse: \(responseData)")
                    if let completion = completion {
                        completion(newPosts: [])
                    }
                    return
        }
        
        dispatch_async(dispatch_get_main_queue(), {
        
            let posts = jsonDictionaries.flatMap({Post(dictionary: $0.1, identifier: $0.0)})
            let sortedPosts = posts.sort({$0.0.timestamp > $0.1.timestamp})
            
            if reset {
                self.posts = sortedPosts
            } else {
        
                self.posts.appendContentsOf(sortedPosts)
            }
        
        if let completion = completion {
        completion(newPosts: sortedPosts)
            }
        
            return

            })
        }
    }
}

protocol PostControllerDelegate: class {
    
    func postsUpdated(posts: [Post])
}




