//
//  LoginViewController.swift
//  Gitea
//
//  Created by Johann Neuhauser on 14.05.19.
//  Copyright © 2019 Johann Neuhauser. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private func showMainViewController() {
        if let tabBarViewController = storyboard?.instantiateViewController(withIdentifier: "GiteaTabBarController") as? UITabBarController {
            present(tabBarViewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serverTextField.delegate = self
        userTextField.delegate = self
        passwordTextField.delegate = self

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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
//        case serverTextField:
//            // If we have the server text field and the result is nil the regex didn´t match and the input is not allowed
//            if string.range(of: "^(https:\\/\\/)[a-z0-9]+([\\-\\.]{1}[a-z0-9]+)*\\.[a-z]{2,5}(:[0-9]{1,5})?(\\/.*)?$", options: .regularExpression) == nil {
//                return false
//            }
        default:
            debugPrint("LoginViewController.textField(): Triggered by unhandled UITextField")
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            debugPrint("LoginViewController.textFieldShouldEndEditing(): String is nil")
            debugPrint(textField)
            // Allow that no text string is set
            return true
        }
        
        switch textField {
        case serverTextField:
            if text.range(of: "^(https:\\/\\/)[a-z0-9]+([\\-\\.]{1}[a-z0-9]+)*\\.[a-z]{2,5}(:[0-9]{1,5})?(\\/.*)?$", options: .regularExpression) == nil {
                // TODO: Raise a notification that input is not sufficient
                return false
            }
        case userTextField:
            if text.count <= 2 {
                // TODO: Raise a notification that input is not sufficient
                return false
            }
        case passwordTextField:
            if text.count <= 6 {
                // TODO: Raise a notification that input is not sufficient
                return false
            }
        default:
            debugPrint("LoginViewController.textFieldShouldEndEditing(): Triggered by unhandled UITextField")
        }
        return true
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("login button pressed")
        // TODO: Do this only if login was successful
        showMainViewController()
    }
    
}
