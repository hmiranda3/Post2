//
//  NetworkController.swift
//  Post2
//
//  Created by Habib Miranda on 6/2/16.
//  Copyright © 2016 littleJohns. All rights reserved.
//

//The NetworkController will be responsible for building URLs and executing HTTP Requests. It should have a method to return NSData from a URL:
import Foundation

// Here we created an enum that will be used in our perform request for URL function. This contains all of the possible HTTP requests that we can perform on an API. We may not use them all, but that's ok!
class NetworkController {
    enum HTTPMethod: String {
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
    }
    
    //This function is used for accessing and pulling things from the network. An NSURL object represents a URL that can potentially contain the location of a resource on a remote server, the path of a local file on disk, or even an arbitrary piece of encoded data. Data objects let simple allocated buffers (that is, data with no embedded pointers) take on the behavior of Foundation objects; in other words it converts data into something we can use. Completion is included so that you know when the request is complete.
    static func performRequestForURL(url: NSURL, httpMethod: HTTPMethod, urlParameters: [String:String]? = nil, body: NSData? = nil, completion: ((data: NSData?, error: NSError?) -> Void)?) {
        
        //Here we create a requestURL that accesses the url and urlParameters parameters from the function above. This method will make the network call and call the completion closer with the NSData? result.
        let requestURL = urlFromURLParameters(url, urlParameters: urlParameters)
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = httpMethod.rawValue
        request.HTTPBody = body
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if let completion = completion {
                completion(data: data, error: error)
            }
        }
        dataTask.resume()
    }
    
    //An NSURL object represents a URL (URL - used to specify where in the world wide web a page, image, and sound file is) that can potentially contain the location of a resource on a remote server, the path of a local file on disk, or even an arbitrary piece of encoded data.
    //The NSURLComponents class is a class that is designed to parse URLs based on RFC 3986 and to construct URLs from their constituent parts. So it breaks apart a URL and makes more URLs.
    //ResolvingAgainstBaseURLsInitializes a URL components object by parsing the URL from an NSURL object. Returns the initialized URL components object, or nil if the URL could not be parsed.
    static func urlFromURLParameters(url: NSURL, urlParameters: [String: String]?) -> NSURL {
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
        //queryItems: The query URL component as an array of name/value pairs
        //FlatMap:Returns an Array containing the non-nil results of mapping transform over self.
        //An NSURLQueryItem object represents a single name/value pair for an item in the query portion of a URL. You use query items with the queryItems property of an NSURLComponents object.
        components?.queryItems = urlParameters?.flatMap({NSURLQueryItem(name: $0.0, value: $0.1)})
        
        //Here we are sying that if url is equal to the unwrapped value of an optional component of a url to return that url. Otherwise crash the app and print that message.
        if let url = components?.URL {
            return url
        } else {
            fatalError("URL optional is nil")
        }
    }
}
