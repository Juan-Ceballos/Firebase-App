//
//  TabBarViewController.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    private lazy var feedViewController: FeedViewController =   {
        let viewController = FeedViewController()
        viewController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "list.bullet"), tag: 0)
        return viewController
    }()
    
    private lazy var profileViewController: ProfileViewController = {
        let viewController = ProfileViewController()
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 0)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [UINavigationController(rootViewController: feedViewController), profileViewController]
    }

}
