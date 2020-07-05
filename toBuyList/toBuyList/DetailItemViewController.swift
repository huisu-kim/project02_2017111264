//
//  DetailItemViewController.swift
//  toBuyList
//
//  Created by SWUCOMPUTER on 2020/07/05.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailItemViewController: UIViewController {

    @IBOutlet var detailName: UILabel!
    @IBOutlet var detailSite: UILabel!
    
    var detailItem : NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let item = detailItem {
            detailName.text = item.value(forKey: "itemName") as? String
            detailSite.text = item.value(forKey: "itemSite") as? String
        }
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
