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
    
    // constraint textfield
    // disable edit on selecting textfield only through edit button
    
    let profileView = ProfileView()
    
    override func loadView() {
        view = profileView
    }
    
    let databaseService = DatabaseService()
    let storageService = StorageService()
    private let imagePickerController = UIImagePickerController()
    
    
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
        getProfileInfo()
        setupUI()
        profileView.editProfilPhotoButton.addTarget(self, action: #selector(editProfilePhotoButtonPressed), for: .touchUpInside)
        uploadProfilePhoto()
    }
    
    public func setupUI()  {
        profileView.displayNameTextField.text = displayName
        profileView.userEmailLabel.text = userEmail
        
    }
    
    public func getProfileInfo()    {
        databaseService.getProfileInfoForUser { (result) in
            switch result   {
            case.failure(let error):
                print(error)
            case .success(let profileDataBaseInfo):
                self.displayName = profileDataBaseInfo["displayName"] as? String
                self.userEmail = profileDataBaseInfo["email"] as? String
            }
        }
    }
    
    // sets image view with photo in firebase
    public func uploadProfilePhoto()    {
        guard let user = Auth.auth().currentUser else {
            return
        }
        print(user.photoURL?.absoluteString)
        if user.photoURL?.description == nil    {
            profileView.profilePhotoImageView.image = UIImage(systemName: "photo")
        }
        else{profileView.profilePhotoImageView.kf.setImage(with: user.photoURL)}
    }
    
    @objc public func editProfilePhotoButtonPressed(_ sender: UIButton) {
        handleImageEdit()
    }
    
    private func updateDatabaseProfilePhoto(photoURL: String) {
        databaseService.updateDatabaseProfilePhoto(photoURL: photoURL) { (result) in
            switch result {
            case .failure(let error):
                print("failed to update db user: \(error.localizedDescription)")
            case .success:
                print("successfully updated db user")
            }
        }
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
                
                self?.updateDatabaseProfilePhoto(photoURL: url.absoluteString)
                
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
