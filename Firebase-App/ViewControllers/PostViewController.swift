//
//  PostViewController.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import Firebase

protocol PostObjectDelegate: AnyObject {
    func photoAdded(_ postObject: Post, numberOfPost: Int)
}

class PostViewController: UIViewController {
    
    // posting should create/ update post in database
    
    let postView = PostView()
    weak var delegate: PostObjectDelegate?
    
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
            guard let imageUploading = selectedImage
            else { return }
        uploadPhoto(image: imageUploading)
    }
    
    // UUID().uuidString
    private func uploadPhoto(image: UIImage)  {
        guard let user = Auth.auth().currentUser
            else { return }
        storageService.uploadPhoto(postId: "\(user.uid)_\(Date())", image: image) { (result) in
            switch result   {
            case .failure(let error):
                print(error)
            case .success(let url):
                print("good upload")
                
                let newPost = Post(photoURL: url.absoluteString, postDate: Timestamp(date: Date()), postedBy: (user.displayName ?? user.email) ?? "", userId: user.uid)
                
                self.databaseService.createDatabasePost(post: newPost) { (result) in
                    switch result   {
                    case .failure(let error):
                        print(error)
                    case .success:
                        print("created db")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                self.databaseService.getPostCountForCurrentUser { (result) in
                    switch result   {
                    case .failure(let error):
                        print(error)
                    case .success(let numberOfPost):
                        self.delegate?.photoAdded(newPost, numberOfPost: numberOfPost)
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
             alertAction in
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
