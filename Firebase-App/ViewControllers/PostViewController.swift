//
//  PostViewController.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {

    let postView = PostView()
    
    override func loadView() {
        view = postView
    }
    
    private let storageService = StorageService()
    private let databaseService = DatabaseService()
    
    private let imagePickerController = UIImagePickerController()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(didTap(_:)))
        return gesture
    }()
    
    private var selectedImage: UIImage? {
        didSet {
            postView.selectedPhotoImageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imagePickerController.delegate = self
        postView.selectedPhotoImageView.isUserInteractionEnabled = true
        postView.selectedPhotoImageView.addGestureRecognizer(tapGesture)
        postView.uploadButton.addTarget(self, action: #selector(uploadButtonPressed), for: .touchUpInside)
    }
    
    @objc func uploadButtonPressed(_ sender: UIButton) {
        print("upload button")
        guard let user = Auth.auth().currentUser,
        let imageUploading = selectedImage
            else { return }
        uploadPhoto(userId: user.uid, image: imageUploading)
    }
    
    // UUID().uuidString
    private func uploadPhoto(userId: String, image: UIImage)  {
        guard let user = Auth.auth().currentUser
            else { return }
        storageService.uploadPhoto(postId: "\(user.uid)_\(Date())", image: image) { (result) in
            switch result   {
            case .failure(let error):
                print(error)
            case .success(let url):
                print("good upload")
                self.databaseService.getUserAndCount { (result) in
                    switch result   {
                    case .failure(let error):
                        print(error)
                    case .success(let count):
                        self.databaseService.updateDatabaseProfilePhoto(numberOfPost: (count + 1)) { (result) in
                            print()
                        }
                    }
                }
            }
        }
    }
    
    @objc private func didTap(_ gesture: UITapGestureRecognizer)    {
        print("image")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] alertAction in
            
                self?.showImageController(isCameraSelected: false)
                
            }
                
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default)  {
                [weak self] alertAction in
                
                
            }
            
            alertController.addAction(photoLibraryAction)
            alertController.addAction(cameraAction)
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

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        selectedImage = image
        
        dismiss(animated: true)
    }
    
}
