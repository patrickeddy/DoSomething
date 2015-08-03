//
//  AddActivityViewController.swift
//  DoSomething
//
//  Created by Patrick Eddy on 7/2/15.
//  Copyright (c) 2015 Patrick Eddy. All rights reserved.
//

import UIKit
import CoreData

class AddActivityViewController: UIViewController {

    @IBOutlet var newActivityTextField: UITextField!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var activities = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "Activity")
        
        var error:NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
        
        if let results = fetchedResults{
            activities = results as! [NSManagedObject]
        } else {
            println("Could not execute request for activities: \(error)")
        }
        
        // Set the newActivityTextField to be the first responder
        newActivityTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addActivity(sender: AnyObject) {
        // Check to see the activity was entered
        let activityBody = newActivityTextField.text
        if !activityBody.isEmpty{
            // Begin entering activity into MOB and into the cached array
            let entityDescription = NSEntityDescription.entityForName("Activity", inManagedObjectContext: managedObjectContext)
            var activity = NSManagedObject(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
            activity.setValue(activityBody, forKey: "body")
            activities.append(activity)
            
            var error:NSError?
            if !managedObjectContext.save(&error){
                println("Unable to save new activity. Error: \(error)")
            } else{
                println("Activity saved! -> \(activityBody)")
            }
            
            self.dismissViewControllerAnimated(true, completion: {})
        } else {
            // Alert the user they need to enter an activity
            var alertController = UIAlertController(title: "Missing Activity", message: "Sorry, you must enter an activity in the text field to add one.", preferredStyle: .Alert)
            let alertCancelAction = UIAlertAction(title: "Ok", style: .Default, handler:nil)
            alertController.addAction(alertCancelAction)
            self.presentViewController(alertController, animated: true, completion: {})
        }
    }
    @IBAction func didPressCancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    @IBAction func didTapOutside(sender: AnyObject) {
        newActivityTextField.resignFirstResponder()
    }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
}
