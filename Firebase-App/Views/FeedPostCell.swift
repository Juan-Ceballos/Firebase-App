//
//  PostCell.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseAuth
import NetworkHelper
import DataPersistence

class FeedPostCell: UICollectionViewCell  {
    
    private let databaseService = DatabaseService()
    
    public lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .cyan
        return imageView
    }()
    
    private lazy var photoCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "Hey"
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commnonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commnonInit()
    }
    
    public func configureCell(post: Post) {
        guard let user = Auth.auth().currentUser else   {return}
        guard let postPhotoURL = URL(string: post.photoURL)
            else    {
                return
        }
        photoImageView.kf.setImage(with: postPhotoURL)
        photoCommentLabel.text = user.displayName
        
    }
    
    private func commnonInit()  {
        setupPhotoImageViewConstraints()
        setupPhotoCommentLabelConstraint()
    }
    
    private func setupPhotoImageViewConstraints()   {
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7)
        ])
    }
    
    private func setupPhotoCommentLabelConstraint()   {
        addSubview(photoCommentLabel)
        photoCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoCommentLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 22),
            photoCommentLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}
