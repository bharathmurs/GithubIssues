//
//  GHCommentsViewController.swift
//  GithubIssues
//
//  Created by Bharath Urs on 8/15/15.
//  Copyright (c) 2015 Urs. All rights reserved.
//

import UIKit

class GHCommentsViewController: UITableViewController {

    var issue: GHIssue?
    var page = 1
    var comments = [GHComment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comments"
        self.navigationItem.prompt = issue?.issueTitle
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.fetchComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchComments() {
        let githubService = GHService()
        
        githubService.fetchComments(issue!.commentsUrl, page: self.page) { (comments) -> Void in
            self.comments.extend(comments)
            self.tableView.reloadData()
        }
    }

}

extension GHCommentsViewController: UITableViewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
}

extension GHCommentsViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GHTableViewCell", forIndexPath: indexPath) as! GHTableViewCell
        let comment = self.comments[indexPath.row]
        
        cell.title.text = comment.user.username
        cell.body.text = comment.body
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
