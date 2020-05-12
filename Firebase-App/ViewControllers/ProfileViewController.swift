//
//  ProfileViewController.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ProfileViewController: UIViewController {
    
    let profileView = ProfileView()
    
    override func loadView() {
        view = profileView
    }
    
    let databaseService = DatabaseService()
    let storageService = StorageService()
    private let imagePickerController = UIImagePickerController()
    
    var postCount: Int? {
        didSet  {
            profileView.submittedPostCountLabel.text = "You have submitted \(postCount ?? 0) images"
        }
    }
    
    var displayName: String? {
        didSet  {
            profileView.displayNameTextField.text = displayName
        }
    }
    
    private var selectedImage: UIImage? {
        didSet {
            profileView.profilePhotoImageView.image = selectedImage
        }
    }
    
    var userEmail: String?  {
        didSet  {
            profileView.userEmailLabel.text = userEmail
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        imagePickerController.delegate = self
        profileView.displayNameTextField.delegate = self
        getProfileInfo()
        setupUI()
        profileView.editProfilPhotoButton.addTarget(self, action: #selector(editProfilePhotoButtonPressed), for: .touchUpInside)
        uploadProfilePhoto()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getProfileInfo()
        setupUI()
    }
    
    public func setupUI()  {
        profileView.displayNameTextField.text = displayName
        profileView.userEmailLabel.text = userEmail
        
        databaseService.getPostCountForCurrentUser { (result) in
            switch result   {
            case .failure(let error):
                print(error)
            case .success(let postCount):
                self.profileView.submittedPostCountLabel.text = "\(postCount)"
            }
        }
    }
    
    public func getProfileInfo()    {
        guard let user = Auth.auth().currentUser else { return }
        if user.displayName == nil   {
            displayName = user.email
        }
        else {displayName = user.displayName}
        userEmail = user.email
    }
    
    public func uploadProfilePhoto()    {
        guard let user = Auth.auth().currentUser else {
            return
        }
        print(user.photoURL?.absoluteString ?? "")
        if user.photoURL?.description == nil    {
            profileView.profilePhotoImageView.image = UIImage(systemName: "photo")
        }
        else{profileView.profilePhotoImageView.kf.setImage(with: user.photoURL)}
    }
    
    @objc public func editProfilePhotoButtonPressed(_ sender: UIButton) {
        handleImageEdit()
    }
    
    private func handleImageEdit()  {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] alertAction in
            
            self?.showImageController(isCameraSelected: false)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func showImageController(isCameraSelected: Bool)  {
        imagePickerController.sourceType = .photoLibrary
        if isCameraSelected {
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated: true)
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        selectedImage = image
        
        guard let user = Auth.auth().currentUser else { return }
        storageService.uploadPhoto(userId: user.uid, image: selectedImage ?? UIImage(systemName: "photo") ?? UIImage()) { [weak self] (result) in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error uploading photo", message: "\(error.localizedDescription)")
                }
            case .success(let url):
                                
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                request?.photoURL = url
                request?.commitChanges(completion: { [unowned self] (error) in
                    if let error = error {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Error updating profile", message: "Error changing profile: \(error.localizedDescription).")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAlert(title: "Profile Photo Update", message: "Profile successfully updated photo")
                            
                        }
                    }
                })
            }
        }
        
        dismiss(animated: true)
    }
    
}

extension ProfileViewController: UITextFieldDelegate    {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        displayName = textField.text
        
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.displayName = displayName
        request?.commitChanges(completion: { (error) in
            if let error = error {
                print(error)
            } else {
                print("Display Name Changed")
                self.databaseService.updateDatabaseDisplayName(displayName: self.displayName ?? self.userEmail ?? "") { (result) in
                    switch result   {
                    case .failure(let error):
                        print(error)
                    case .success:
                        print()
                    }
                }
            }
        })
        
        textField.resignFirstResponder()
        return true
    }
    
}

extension ProfileViewController: PostObjectDelegate {
    func photoAdded(_ postObject: Post, numberOfPost: Int) {
        postCount = numberOfPost
    }
    
}
