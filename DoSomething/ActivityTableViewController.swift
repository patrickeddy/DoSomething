//
//  ActivityTableViewController.swift
//  DoSomething
//
//  Created by Patrick Eddy on 6/29/15.
//  Copyright (c) 2015 Patrick Eddy. All rights reserved.
//

import UIKit
import CoreData

class ActivityTableViewController: UITableViewController, UITableViewDataSource {
    
    // Get managed object context for Core Data objects
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var activities = [NSManagedObject]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest(entityName: "Activity")
        var error:NSError?
        let fetchedResults = managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
        if let results = fetchedResults{
            activities = results as! [NSManagedObject]
        } else {
            println("Could not make request. Error: \(error)")
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return activities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        if (activities.count > 0){
            let activity = activities[indexPath.row]
            cell.textLabel!.text = activity.valueForKey("body") as? String
        }
    
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            // Delete the row from the data source
            if (activities.count > 0){
                
                // Delete the NSManagedObject
                managedObjectContext?.deleteObject(activities[indexPath.row])
                
                // Finally, remove from the array
                activities.removeAtIndex(indexPath.row)
                
                var error:NSError?
                if !managedObjectContext!.save(&error){
                    println("Couldn't delete the object. \(error)")
                }
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    @IBAction func addActivity(sender: AnyObject) {
        let entityDescription = NSEntityDescription.entityForName("Activity", inManagedObjectContext: managedObjectContext!)
        var activity = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        
        activity.setValue("Pie", forKey: "body")

        var error:NSError?
        if !managedObjectContext!.save(&error){
                println("Unable to save new activity: \(error)")
        }
        activities.append(activity)
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }*/
}
