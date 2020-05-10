//
//  PostView.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

class PostView: UIView  {
    public lazy var photoLibraryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Photo Library", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    public lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        return button
    }()
    
    public lazy var toolbarPhotoLibraryButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(customView: photoLibraryButton)
        return barButtonItem
    }()
    
    public lazy var toolbarCameraButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(customView: cameraButton)
        return barButtonItem
    }()
    
    public lazy var addPhotoToolbar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.items = [toolbarPhotoLibraryButton, toolbarCameraButton]
        return toolbar
    }()
    
    public lazy var uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Upload", for: .normal)
        return button
    }()
    
    public lazy var selectedPhotoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .purple
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        setupSelectedPhotoImageViewConstraints()
        setupSaveButtonConstraints()
        //setupAddPhotoToolbar()
    }
    
    private func setupSelectedPhotoImageViewConstraints()   {
        addSubview(selectedPhotoImageView)
        
        selectedPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectedPhotoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectedPhotoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectedPhotoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectedPhotoImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4)
        ])
    }
    
    private func setupSaveButtonConstraints()   {
        addSubview(uploadButton)
        
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            uploadButton.topAnchor.constraint(equalTo: selectedPhotoImageView.bottomAnchor, constant: 11),
            uploadButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func setupAddPhotoToolbar() {
        addSubview(addPhotoToolbar)
        
        addPhotoToolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addPhotoToolbar.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            addPhotoToolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            addPhotoToolbar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
