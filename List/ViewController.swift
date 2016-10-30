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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(tableViewController.addItem))
        self.navigationItem.title = "To-do"
    }
    
    func addItem(){
        let alertController = UIAlertController(title: "Add To-do", message: "Keep it simple..", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: ({
            (_) in
            if let field = alertController.textFields![0] as? UITextField {
                
                self.saveItem(field.text!)
                self.tableView.reloadData()
            }
            
        }
        ))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertController.addTextField(configurationHandler: {
            (textField) in
            
            textField.placeholder = "Type in something"
            textField.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
            textField.textColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)

            
            
        })
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil )
    }

    func saveItem(_ itemToSave: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ListEntity", in: managedContext)
        
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        item.setValue(itemToSave, forKey: "item")
        
        do  {
            
            try managedContext.save()
            listItems.append(item)
            
        } catch {
            
            print("Error")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.right)
        
        managedContext.delete(listItems[(indexPath as NSIndexPath).row])
        listItems.remove(at: (indexPath as NSIndexPath).row)
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ListEntity")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            listItems = results as! [NSManagedObject]
        } catch {
            print("Error")
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        
        let item = listItems[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = item.value(forKey: "item") as! String
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 32.0)
        cell.textLabel?.textColor = UIColor(red:0.25, green:0.25, blue:0.25, alpha:1.0)
        
        if ((cell.textLabel?.text?.range(of: "!")) != nil){
        
            cell.textLabel?.textColor = UIColor.red
        }
        
        if ((cell.textLabel?.text?.range(of: "999")) != nil) {
            cell.textLabel?.textColor = UIColor.red
        }
        
        
        return cell
    }
}

