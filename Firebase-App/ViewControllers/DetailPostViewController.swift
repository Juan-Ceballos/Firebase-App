//
//  DetailPostViewController.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import Kingfisher

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
        guard let currentPost = post  else  {
            fatalError()
        }
        
        guard let postPhotoURL = URL(string: currentPost.photoURL)
            else    {
                return
        }
        detailView.photoImageView.kf.setImage(with: postPhotoURL)
        detailView.displayNameLabel.text = post?.postedBy
        detailView.createdAtLabel.text = post?.postDate.dateValue().dateString()
    }

}
