//
//  MainAddViewController.swift
//  toBuyList
//
//  Created by SWUCOMPUTER on 2020/07/05.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class MainAddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var toBuy: UITextField!
    @IBOutlet var timeLimit: UIDatePicker!
    @IBOutlet var buttonDone: UIBarButtonItem!
    
    //text에 글이 없다면 완료하지 못하게 하는 함수
    func cannotDone() {
        if toBuy.text! == ""{
               buttonDone.isEnabled = false
        } else {
            buttonDone.isEnabled = true
        }
    }
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        cannotDone()
        return true
    }
    
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    

    var date : Date = Date()
    var stringDate : String = ""
    
    @IBAction func getDateTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        date =  self.timeLimit.date
        stringDate = dateFormatter.string(from: self.timeLimit.date)
    }
    
    @IBAction func saveToBuy(_ sender: UIBarButtonItem) {
        let context = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Buy", in: context)
        
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        object.setValue(toBuy.text, forKey: "toBuy")
        object.setValue(date , forKey: "priorityDate")
        object.setValue(stringDate, forKey: "stringDate")
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cannotDone()
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
