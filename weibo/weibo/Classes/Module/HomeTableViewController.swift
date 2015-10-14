//
//  HomeTableViewController.swift
//  weibo1
//
//  Created by 杨晓晨 on 15/10/7.
//  Copyright © 2015年 yangxiaochen. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseViewController {
    var statuses: [Status]? {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "狗仔私人微博"
        navigationController?.navigationBar.tintColor = UIColor.orangeColor()
        // 设置表格的预估行高(方便表格提前计算预估行高，提高性能)
        tableView.estimatedRowHeight = 200
        // 设置表格自动计算行高
        tableView.rowHeight = UITableViewAutomaticDimension
        // 取消分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(StatusCell.self, forCellReuseIdentifier: "Cell")
        
        visitView.setupViewInfo(true, imageName: "visitordiscover_feed_image_smallicon", message: "关注一些人，回这里看看有什么惊喜")

        Status.loadStatus { [weak self](dataList, error) -> () in
            if error != nil {
                print("微博数组没有拿到")
                
                print(error)
                return
            }
            self?.statuses = dataList
            self!.tableView.reloadData()
            //print(self?.statuses)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (statuses?.count) ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! StatusCell
        cell.status = statuses![indexPath.row]
        

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
