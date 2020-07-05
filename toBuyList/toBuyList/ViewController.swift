//
//  ViewController.swift
//  toBuyList
//
//  Created by SWUCOMPUTER on 2020/07/05.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var loginID: UITextField!
    @IBOutlet var loginPassword: UITextField!
    @IBOutlet var statusLabel: UILabel!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.loginID {
            textField.resignFirstResponder()
            self.loginPassword.becomeFirstResponder()
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func buttonLogin(_ sender: UIButton) {
        
        if loginID.text == "" {
            statusLabel.text = "ID를 입력하세요";
            return;
        }
        
        if loginPassword.text == "" {
            statusLabel.text = "비밀번호를 입력하세요";
            return;
        }
        
        let urlString : String = "http://condi.swu.ac.kr/student/M04/project2/loginUser.php"
       
        guard let requestURL = URL(string: urlString) else {
            return
        }
        self.statusLabel.text = " "
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + loginID.text! + "&password=" + loginPassword.text!
        
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {(responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
            
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
            
            do {
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode) {
                    print (response.statusCode)
                    print ("HTTP Error!")
                    return
                }
                
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [String: Any] else {
                    print("JSON Serialization Error!")
                    return
                }
                
                guard let success = jsonData["success"] as? String else {
                    print("Error: PHP failure(success)")
                    return
                }
                
                if success == "YES" {
                    if let name = jsonData["name"] as? String {
                        DispatchQueue.main.async {
                            self.statusLabel.text = name + "님 안녕하세요?"
                            
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.ID = self.loginID.text
                            appDelegate.userName = name
                            
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let naviViewController = storyboard.instantiateViewController(withIdentifier: "naviView")
                            naviViewController.modalPresentationStyle = .fullScreen
                            self.present(naviViewController, animated: true, completion: nil)
                        }
                    }
                } else {
                    if let errMessage = jsonData["error"] as? String {
                        DispatchQueue.main.async {
                            self.statusLabel.text = errMessage
                        }
                    }
                }
                
            } catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

