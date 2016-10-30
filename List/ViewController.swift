//
//  ViewController.swift
//  List
//
//  Created by Thomas Meehan on 21/08/2016.
//  Copyright © 2016 com.test. All rights reserved.
//

import UIKit
import CoreData

class tableViewController: UITableViewController {

    var listItems = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addItem"))
        self.navigationItem.title = "To-do"
    }
    
    func addItem(){
        let alertController = UIAlertController(title: "Add To-do", message: "Keep it simple..", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: ({
            (_) in
            if let field = alertController.textFields![0] as? UITextField {
                
                self.saveItem(field.text!)
                self.tableView.reloadData()
            }
            
        }
        ))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addTextFieldWithConfigurationHandler({
            (textField) in
            
            textField.placeholder = "Type in something"
            textField.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
            textField.textColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)

            
            
        })
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil )
    }

    func saveItem(itemToSave: String){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entityForName("ListEntity", inManagedObjectContext: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        item.setValue(itemToSave, forKey: "item")
        
        do  {
            
            try managedContext.save()
            listItems.append(item)
            
        } catch {
            
            print("Error")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        
        managedContext.deleteObject(listItems[indexPath.row])
        listItems.removeAtIndex(indexPath.row)
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ListEntity")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            listItems = results as! [NSManagedObject]
        } catch {
            print("Error")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        let item = listItems[indexPath.row]
        
        cell.textLabel?.text = item.valueForKey("item") as! String
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 32.0)
        cell.textLabel?.textColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
        
        if ((cell.textLabel?.text?.rangeOfString("!")) != nil){
        
            cell.textLabel?.textColor = UIColor.redColor()
        }
        
        if ((cell.textLabel?.text?.rangeOfString("999")) != nil) {
            cell.textLabel?.textColor = UIColor.redColor()
        }
        
        
        return cell
    }
}

