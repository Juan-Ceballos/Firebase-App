//
//  LoginViewController.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    
    override func loadView() {
        view = loginView
    }
    
    private var authSession = AuthenticationSession()
    private var databaseService = DatabaseService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loginView.emailTextField.delegate = self
        loginView.passwordTextField.delegate = self
        loginView.loginButton.addTarget(self, action: #selector(loginButtonPressed(_:)), for: .touchUpInside)
        loginView.createAccountButton.addTarget(self, action: #selector(createAccountButtonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func loginButtonPressed(_ sender: UIButton) {
        guard let email = loginView.emailTextField.text,
            !email.isEmpty,
            let password = loginView.passwordTextField.text,
            !password.isEmpty
        else    {
            print("missing fields")
            return
        }
        
        loginExistingUser(email: email, password: password)
    }

    @objc func createAccountButtonPressed(_ sender: UIButton) {
        guard let email = loginView.emailTextField.text,
            !email.isEmpty,
            let password = loginView.passwordTextField.text,
            !password.isEmpty
        else    {
            print("missing fields")
            return
        }
        
        createNewUser(email: email, password: password)
    }
    
    private func loginExistingUser(email: String, password: String) {
        authSession.loginExistingUser(email: email, password: password) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success:
              DispatchQueue.main.async {
                self?.navigateToMainView()
              }
            }
          }
    }
    
    private func createNewUser(email: String, password: String) {
        authSession.createNewUser(email: email, password: password) { [weak self] (result) in
            switch result   {
            case .failure(let error):
                print(error.localizedDescription)
            case .success:
                self?.navigateToMainView()
            }
        }
    }
    
    
    
    private func navigateToMainView()   {
        // create instance tabBarVC?
        UIViewController.showVC(viewcontroller: TabBarViewController())
    }

}

extension LoginViewController: UITextFieldDelegate  {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


