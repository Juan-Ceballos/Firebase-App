//
//  DetailPostView.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

// image, 2 labels

import UIKit

class DetailPostView: UIView {
    
    public lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    public lazy var displayNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    public lazy var createdAtLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit()   {
        setupPhotoImageViewConstraints()
        setupDisplayNameLabelConstraints()
        setupCreatedAtConstraints()
    }
    
    private func setupPhotoImageViewConstraints()   {
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            photoImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.35)
        
        ])
    }
    
    private func setupDisplayNameLabelConstraints() {
        addSubview(displayNameLabel)
        displayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            displayNameLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
            displayNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        ])
    }
    
    private func setupCreatedAtConstraints()    {
        addSubview(createdAtLabel)
        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        
            createdAtLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 8),
            createdAtLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        
        ])
    }
    
}
