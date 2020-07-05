//
//  CreateViewController.swift
//  toBuyList
//
//  Created by SWUCOMPUTER on 2020/07/05.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var createID: UITextField!
    @IBOutlet var createPassword: UITextField!
    @IBOutlet var createPwAgain: UITextField!
    @IBOutlet var createName: UITextField!
    @IBOutlet var labelStatus: UILabel!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.createID {
            textField.resignFirstResponder()
            self.createPassword.becomeFirstResponder()
        }
        else if textField == self.createPassword {
            textField.resignFirstResponder()
            self.createPwAgain.becomeFirstResponder()
        }
        else if textField == self.createName {
            textField.resignFirstResponder()
            self.createName.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signUp(_ sender: Any) {
        if createID.text == "" {
            labelStatus.text = "ID를 입력하세요"
            return
        }
        if createPassword.text == "" {
            labelStatus.text = "비밀번호를 입력하세요"
            return
        }
        if createPwAgain.text == "" {
            labelStatus.text = "비밀번호를 다시 한 번 입력하세요"
            return
        }
        if createPassword.text != createPwAgain.text {
            labelStatus.text = "비밀번호가 일치하지 않습니다"
            print("야야야")
            return
        }
        if createName.text == "" {
            labelStatus.text = "닉네임을 입력하세요"
            return
        }
        
        let urlString : String = "http://condi.swu.ac.kr/student/M04/project2/insertUser.php"
        guard let requestURL = URL(string : urlString) else {
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + createID.text! + "&password=" + createPassword.text! + "&name=" + createName.text!
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                print("Error: calling POST")
                return
            }
                   
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return
            }
                   
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async { // for Main Thread Checker
                    self.labelStatus.text = utf8Data
                    print(utf8Data) // php에서 출력한 echo data가 debug 창에 표시됨
                }
            }
                       
        }
        task.resume()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
