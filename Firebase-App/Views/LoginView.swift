//
//  LoginView.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import SnapKit

class LoginView: UIView {
    
    private lazy var profileSignInStackView: UIStackView =   {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(createAccountButton)
        
        return stackView
    }()
    
    public lazy var emailTextField: UITextField =   {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.placeholder = "Email"
        return textField
    }()
    
    public lazy var passwordTextField: UITextField =   {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.placeholder = "Password"
        return textField
    }()
    
    public lazy var loginButton: UIButton =   {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        return button
    }()
    
    public lazy var createAccountButton: UIButton =   {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        return button
    }()
    
    public lazy var errorLabel: UILabel =   {
        let label = UILabel()
        label.textAlignment = .center
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder)  {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit()   {
        setupProfileSigninStackViewConstraints()
        setupErrorLabelConstraints()
    }
    
    private func setupProfileSigninStackViewConstraints()  {
        addSubview(profileSignInStackView)
        profileSignInStackView.snp.makeConstraints { (make) in
            make.left.equalTo(self).inset(8)
            make.right.equalTo(self).inset(-8)
            make.height.equalTo(self).multipliedBy(0.2)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(40)
        }
    }
    
    private func setupErrorLabelConstraints()   {
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileSignInStackView.snp.bottom).offset(8)
            make.left.equalTo(self.snp.left).offset(8)
            make.right.equalTo(self.snp.right).inset(8)
            make.bottom.equalTo(self.snp.bottom)
        }
    }
    
}
