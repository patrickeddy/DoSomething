//
//  AddActivityViewController.swift
//  DoSomething
//
//  Created by Patrick Eddy on 7/2/15.
//  Copyright (c) 2015 Patrick Eddy. All rights reserved.
//

import UIKit
import CoreData

class AddActivityViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    // Properties
    @IBOutlet var newActivityTextField: UITextField!
    @IBOutlet var activityImageView: UIImageView!
    var activityImageFilePath:String = ""
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    var activities = [NSManagedObject]()
    var picker = UIImagePickerController()
    
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
            activity.setValue(activityImageFilePath, forKey: "imagePath")
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
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func didPressCancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func dismissKeyboard(sender: AnyObject){
        newActivityTextField.resignFirstResponder()
    }
    @IBAction func didTapAddImageButton(sender: AnyObject) {
        // Do some setup to the picker
        picker = UIImagePickerController()
        picker.delegate = self
        picker.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.allowsEditing = false
        
        // Check to see if this device has a camera
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            presentViewController(picker, animated: true, completion: nil)
        }else{
            println("Device does not have camera. Sorry")
        }
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        // Dismiss picker controller
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        // Unnecessary logging goes here... For fun.
//        println("Picture taken. didFinishPickingMediaWithInfo called.")
//        
//        println("Info count: \(info.count)")
//        print("\(info)")
        
        // Get the UIImagePickerControllerOriginalImage and set it as preview.
        let image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        if image != nil {
            activityImageView.image = image

            // Save the damn thing.
            let pngData = UIImageJPEGRepresentation(image, 0.8)
            var paths:[AnyObject] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            
            let documentsPath:String = paths[0] as! String
            let filePath = documentsPath.stringByAppendingPathComponent("\(image!.hashValue).png")
            println("Filepath:\n\(filePath)")
            
            pngData.writeToFile(filePath, atomically: true)
            
            // Set the controllers activityImageFilePath to the current images saved filepath
            activityImageFilePath = "\(image!.hashValue).png"

        
        } // Oops, no image. What happened?
        else {
            println("Could not set the activityImageView's image")
        }
        
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: {})
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
