//
//  ItemTableViewController.swift
//  toBuyList
//
//  Created by SWUCOMPUTER on 2020/07/05.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class ItemTableViewController: UITableViewController {

    var items : [NSManagedObject] = []
    
    var detailItem : NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
      
    }
    
    @IBAction func checkButton(_ sender: UISwitch) {

        let context = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Items", in: context)
        
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        if sender.isOn {
            object.setValue(true, forKey: "itemCheck")
        } else {
            object.setValue(false, forKey: "itemCheck")
        }
        
    }
    
    func getContext() -> NSManagedObjectContext {
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              return appDelegate.persistentContainer.viewContext
       }
       
       override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            let context = self.getContext()
            let fetchRequest = NSFetchRequest<NSManagedObject> (entityName: "Items")
            
            let sortDescriptor = NSSortDescriptor (key: "itemName", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                items = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            
            self.tableView.reloadData()
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item Cell", for: indexPath)

        // Configure the cell...
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.value(forKey: "itemName") as? String
        cell.detailTextLabel?.text = item.value(forKey: "itemSite") as? String
        

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let context = getContext()
            context.delete(items[indexPath.row])
            do {
                try context.save()
                print("deleted!")
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)")
            }
            items.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier ==  "toDetailView" {
                  if let destination = segue.destination as? DetailItemViewController {
                      if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                          destination.detailItem = items[selectedIndex]
                      }
                  }
              }
    }
    

}
