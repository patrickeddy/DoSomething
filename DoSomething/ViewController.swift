//
//  ViewController.swift
//  DoSomething
//
//  Created by Patrick Eddy on 6/29/15.
//  Copyright (c) 2015 Patrick Eddy. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var randomActivityView: UITextView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    var activities = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        fetchActivities()
        displayActivity()
        println("viewWillAppear: Displaying activity...")
    }
    @IBAction func tappedOnActivity(sender: AnyObject) {
        displayActivity()
    }
    func displayActivity(){
        // Randomly select an activity and display it
        if (activities.count > 0){
        let randNumber = abs(random() % (activities.count))
            let activity = activities[randNumber]
            randomActivityView.text = activity.valueForKey("body") as! String
            randomActivityView.textColor = UIColor.whiteColor()
            randomActivityView.textAlignment = NSTextAlignment.Center
            randomActivityView.font = UIFont(name: "Helvetica-Bold", size: 30.0)
        } else {
            println("Can't display an activity because there aren't any!")
        }
    }
    
    func fetchActivities (){
        let fetchRequest = NSFetchRequest(entityName: "Activity")
        var error:NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error)
        if let results = fetchedResults{
            activities = results as! [NSManagedObject]
        } else {
            println("Couldn't fetch activities... Error: \(error)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

