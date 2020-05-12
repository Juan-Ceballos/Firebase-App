//
//  FeedViewController.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import FirebaseAuth

class FeedViewController: UIViewController {
    
    private let feedView = FeedView()
    
    override func loadView() {
        view = feedView
    }
    
    private let authSession = AuthenticationSession()
    private let databaseService = DatabaseService()
    
    var feedPosts = [Post]()    {
        didSet  {
            feedView.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        feedView.collectionView.register(FeedPostCell.self, forCellWithReuseIdentifier: "feedPostCell")
        feedView.collectionView.dataSource = self
        feedView.collectionView.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(uploadPhoto))
        navigationItem.title = "Pursuitstagram"
        //authSession.signOutCurrentUser()
        //UIViewController.showVC(viewcontroller: LoginViewController())
        setupPostFeed()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        feedView.collectionView.reloadData()
    }
    
    private func setupPostFeed()    {
        databaseService.getUserPosts { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let posts):
                self.feedPosts = posts
            }
        }
    }
    
    @objc private func uploadPhoto()  {
        print("upload")
        let postVC = PostViewController()
        postVC.delegate = self
        navigationController?.pushViewController(postVC, animated: false)
    }

}

extension FeedViewController: UICollectionViewDataSource    {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedPostCell", for: indexPath) as? FeedPostCell else {
            fatalError()
        }
        
        let feedPostObject = feedPosts[indexPath.row]
        cell.configureCell(post: feedPostObject)
        return cell
    }
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout    {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize: CGSize = UIScreen.main.bounds.size
        let itemWidth: CGFloat = maxSize.width
        let itemHeight: CGFloat = maxSize.height * 0.40
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailPostViewController()
        detailVC.post = feedPosts[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: false)
    }
    
}

extension FeedViewController: PostObjectDelegate    {
    func photoAdded(_ postObject: Post, numberOfPost: Int) {
        feedPosts.append(postObject)
    }
    
}
