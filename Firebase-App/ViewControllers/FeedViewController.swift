//
//  FeedViewController.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import FirebaseAuth

class FeedViewController: UIViewController {
    
    private let authSession = AuthenticationSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
//        authSession.signOutCurrentUser()
//        UIViewController.showVC(viewcontroller: LoginViewController())
    }

}
