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
        //serverTextField.text = "https://git.it-neuhauser.de"
        serverTextField.text = "https://try.gitea.io"
        userTextField.text = "devel"
        passwordTextField.text = "DasIstEinTestUser"
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let server = serverTextField.text, let user = userTextField.text, let password = passwordTextField.text {
            let auth = Authentication.shared
            _ = auth.setServer(fromString: server)
            auth.setAuthentication(withUser: user, andPassword: password)
        }
        
        Networking.shared.getAuhtenticatedUser() { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.showMainViewController()
                }
            case .failure(let error):
                debugPrint("getAuhtenticatedUser(): failed with \(error)")
                DispatchQueue.main.async {
                    if let httpError = error as? URLSession.HTTPError {
                        switch httpError {
                        case .serverSideError(401):
                            self.showToast(message: "User or password wrong")
                        case .serverSideError(404):
                            self.showToast(message: "Server address wrong")
                        case .serverSideError(500...599):
                            self.showToast(message: "Server error")
                        case .transportError(_):
                            self.showToast(message: "Transport error")
                        default:
                            self.showToast(message: "Unknown http error: \(httpError)")
                        }
                    } else {
                        self.showToast(message: "Unknown error: \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
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
                self.showToast(message: "Not a valid server address")
                return false
            }
        case userTextField:
            if text.count < 2 {
                self.showToast(message: "Not a valid user name")
                return false
            }
        case passwordTextField:
            if text.count < 6 {
                self.showToast(message: "Not a valid password")
                return false
            }
        default:
            debugPrint("LoginViewController.textFieldShouldEndEditing(): Triggered by unhandled UITextField")
        }
        return true
    }
    
}
