//
//  ProfileCell.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import Foundation
import SnapKit

import UIKit

class ProfileView: UIView {
    
    public lazy var profilePhotoImageView: UIImageView =    {
        let imageView = UIImageView()
        return imageView
    }()
    
    public lazy var editProfilPhotoButton: UIButton =   {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    public lazy var displayNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "display name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    public lazy var editDisplayNameButton: UILabel =   {
        let label = UILabel()
        label.text = "Display Name:"
        return label
    }()
    
    public lazy var userEmailLabel: UILabel =   {
        let label = UILabel()
        label.text = "email here"
        return label
    }()
    
    public lazy var submittedPostCountLabel: UILabel =  {
        let label = UILabel()
        label.text = "You have submitted: x images"
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
        setupProfilePhotoImageViewConstraints()
        setupEditProfilePhotoButtonConstraints()
        setupEditDisplayNameButtonConstraints()
        setupDisplayNameTextFieldConstraints()
        setupUserEmailLabelConstraints()
        setupSubmittedPostCountLabelConstraints()
    }
    
    private func setupProfilePhotoImageViewConstraints()    {
        addSubview(profilePhotoImageView)
        
        profilePhotoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
    }
    
    private func setupEditProfilePhotoButtonConstraints()    {
        addSubview(editProfilPhotoButton)
        
        editProfilPhotoButton.snp.makeConstraints { (make) in
            make.top.equalTo(profilePhotoImageView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(8)
        }
    }
    
    private func setupEditDisplayNameButtonConstraints()    {
        addSubview(editDisplayNameButton)
        
        editDisplayNameButton.snp.makeConstraints { (make) in
            make.top.equalTo(editProfilPhotoButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupDisplayNameTextFieldConstraints()    {
        addSubview(displayNameTextField)
        
        displayNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(editDisplayNameButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupUserEmailLabelConstraints()    {
        addSubview(userEmailLabel)
        
        userEmailLabel.snp.makeConstraints { (make) in
            make.top.equalTo(displayNameTextField.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupSubmittedPostCountLabelConstraints()    {
        addSubview(submittedPostCountLabel)
        
        submittedPostCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userEmailLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}
