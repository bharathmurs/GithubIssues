//
//  GHIssuesViewController.swift
//  GithubIssues
//
//  Created by Bharath Urs on 8/15/15.
//  Copyright (c) 2015 Urs. All rights reserved.
//

import UIKit

class GHIssuesViewController: UITableViewController {

    var issues = [GHIssue]()
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Issues"

        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.fetchIssues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = sender as! NSIndexPath
        let controller = segue.destinationViewController as! GHCommentsViewController
        controller.issue = self.issues[indexPath.row]
    }

    func fetchIssues() {
        let githubService = GHService()
        
        githubService.fetchIssuesOnPage(self.page, completionHandler: { (issues) -> Void in
            self.issues.extend(issues)
            self.tableView.reloadData()
            self.page += 1
        })
    }

}

extension GHIssuesViewController: UITableViewDataSource {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.issues.count
    }
}

extension GHIssuesViewController: UITableViewDelegate {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GHTableViewCell", forIndexPath: indexPath) as! GHTableViewCell
        let issue = self.issues[indexPath.row]
        cell.title.text = issue.issueTitle
        
        var body = issue.issueBody
        if count(issue.issueBody) > CONSTANTS.GH_CHARACTER_LIMIT {
            body = issue.issueBody.substringToIndex(advance(body.startIndex, CONSTANTS.GH_CHARACTER_LIMIT))
            body = body + "..."
        }
        cell.body.text = body
        cell.footer.text = issue.numberOfCommentsString
        
        if(indexPath.row == self.issues.count - 1) {
            self.fetchIssues()
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("pushComments", sender: indexPath)
    }
}

class GHTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    @IBOutlet weak var footer: UILabel!
}
