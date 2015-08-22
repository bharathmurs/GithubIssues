//
//  Github.swift
//  GithubIssues
//
//  Created by Bharath Urs on 8/15/15.
//  Copyright (c) 2015 Urs. All rights reserved.
//

import Foundation

class GHUser {
    var username: String
    var avatar: String
    
    init() {
        username = ""
        avatar = ""
    }
}

class GHIssue {
    var user: GHUser
    var issueTitle: String
    var issueBody: String
    var numberOfComments: Int
    var commentsUrl: String
    
    init() {
        user = GHUser()
        issueTitle = ""
        issueBody = ""
        commentsUrl = ""
        numberOfComments = 0
    }
    
    class func parseGithubIssuesWithJSON(json: NSArray) -> [GHIssue] {
        var issues = [GHIssue]()
        
        for j in json {
            var issue = GHIssue()
            if let title = j["title"] as? String { issue.issueTitle = title }
            if let body = j["body"] as? String { issue.issueBody = body }
            if let numberOfComments = j["comments"] as? Int { issue.numberOfComments = numberOfComments }
            if let commentsUrl = j["comments_url"] as? String { issue.commentsUrl = commentsUrl }
            
            if let user = j["user"] as? NSDictionary {
                if let username = user["login"] as? String { issue.user.username = username }
                if let avatar = user["avatar_url"] as? String { issue.user.avatar = avatar }
            }
            issues.append(issue)
        }
        return issues
    }
    
    var numberOfCommentsString: String {
        if(numberOfComments == 1) { return "\(numberOfComments) comment" }
        return "\(numberOfComments) comments"
    }
}


class GHComment {
    var user: GHUser
    var body: String
    
    init() {
        user = GHUser()
        body = ""
    }
    
    class func parseGithubCommentsWithJSON(json: NSArray) -> [GHComment] {
        var comments = [GHComment]()
        
        for j in json {
            var comment = GHComment()
            if let body = j["body"] as? String { comment.body = body }
            
            if let user = j["user"] as? NSDictionary {
                if let username = user["login"] as? String { comment.user.username = username }
                if let avatar = user["avatar_url"] as? String { comment.user.avatar = avatar }
            }
            comments.append(comment)
        }
        return comments
    }
}

