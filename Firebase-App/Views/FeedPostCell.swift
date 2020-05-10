//
//  PostCell.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

class FeedPostCell: UICollectionViewCell  {
    private lazy var photoImageView: UIImageView = {
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
        
//        @objc public func editPressed(_ sender: UIButton!)  {
//            print("edit button pressed")
//            self.delegate?.buttonPressed(tag: sender.tag, currentCell: self)
//        }
        
        override init(frame: CGRect) {
            super.init(frame: UIScreen.main.bounds)
            commnonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commnonInit()
        }
        
//        public func configureCell(photoObject: PhotoObject)    {
//            photoImageView.image = UIImage(data: photoObject.imageData)
//            photoCommentLabel.text = photoObject.photoComment
//            postDateLabel.text = photoObject.convertedDate
//        }
        
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
