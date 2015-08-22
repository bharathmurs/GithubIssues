//
//  GHService.swift
//  GithubIssues
//
//  Created by Bharath Urs on 8/15/15.
//  Copyright (c) 2015 Urs. All rights reserved.
//

import Foundation

enum RequestType : String {
    case GET = "GET"
}

class GHService: NSObject {
    let BASE_URL = "https://api.github.com/repos/rails/rails"
    let API_ISSUES = "/issues"
    
    private func _getURLForAPI(api: String) -> NSURL {
        var url : String = BASE_URL + api
        return NSURL(string: url)!
    }
    
    private func _getRequestWithType(type: RequestType) -> NSMutableURLRequest {
        var request : NSMutableURLRequest = NSMutableURLRequest()
        request.setValue("token " + CONSTANTS.AUTH_TOKEN, forHTTPHeaderField: "Authorization")
        request.HTTPMethod = type.rawValue
        return request
    }
    
    private func sendAsyncRequestWithRequest(request: NSMutableURLRequest, completionHandler: ((NSArray!) -> Void)) {
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue(), completionHandler:{ (response:NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            var jsonError: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            let jsonParse: NSArray? = NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: jsonError) as? NSArray
            if let json = jsonParse {
                completionHandler(json)
            } else {
                var dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println(error)
                println(dataString)
            }

        })
    }
    
    func fetchIssuesOnPage(page: Int, completionHandler: (([GHIssue])->Void)) {
        let request = _getRequestWithType(.GET)
        let urlString = API_ISSUES + "?sort=updated&page=\(page)"
        request.URL = _getURLForAPI(urlString)
        
        self.sendAsyncRequestWithRequest(request, completionHandler: { (json) -> Void in
            let issues = GHIssue.parseGithubIssuesWithJSON(json)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(issues)
            })
        })
    }
    
    
    func fetchComments(commentsUrl: String, page:Int, completionHandler: (([GHComment]) -> Void)) {
        let request = _getRequestWithType(.GET)
        let urlString = commentsUrl + "?sort=updated&page=\(page)"
        request.URL = NSURL(string: urlString)

        self.sendAsyncRequestWithRequest(request, completionHandler: { (json) -> Void in
            let comments = GHComment.parseGithubCommentsWithJSON(json)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(comments)
            })
        })
    }
}
