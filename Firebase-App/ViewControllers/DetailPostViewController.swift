//
//  DetailPostViewController.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth

class DetailPostViewController: UIViewController {

    private let detailView = DetailPostView()
    
    override func loadView() {
        view = detailView
    }
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setupUI()
    }
    
    private func setupUI()  {
        guard let currentPost = post,
            let user = Auth.auth().currentUser else  {
            fatalError()
        }
        
        guard let postPhotoURL = URL(string: currentPost.photoURL)
            else    {
                return
        }
        detailView.photoImageView.kf.setImage(with: postPhotoURL)
        detailView.displayNameLabel.text = user.displayName
        detailView.createdAtLabel.text = post?.postDate.dateValue().dateString()
    }

}
