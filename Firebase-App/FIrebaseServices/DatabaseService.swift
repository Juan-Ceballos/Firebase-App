//
//  DatabaseService.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseService   {
        
    static let usersCollection = "users"
    static let postsCollection = "posts"
    
    private let db = Firestore.firestore()
    
    public func createDatabasePost(post: Post,
    completion: @escaping (Result<Bool, Error>) -> ())    {
        
        db.collection(DatabaseService.postsCollection).addDocument(data: [
            "createdBy": post.postedBy,
            "photoURL": post.photoURL,
            "postId": post.postId,
            "datePosted": post.postDate,
            "userId": post.userId]) { (error) in
                if let error = error    {
                    completion(.failure(error))
                }
                else    {
                    completion(.success(true))
                }
        }
    }
    
    public func getPostCountForCurrentUser(completion: @escaping (Result<Int, Error>) -> ())    {
        guard let user = Auth.auth().currentUser else   {return}
        db.collection(DatabaseService.postsCollection).whereField("userId", isEqualTo: user.uid).getDocuments { (snapshot, error) in
            if let error = error    {
                completion(.failure(error))
            }
            else if let snapshot = snapshot {
                let numberOfPostsFromUser = snapshot.count
                completion(.success(numberOfPostsFromUser))
            }
        }
    }
    
    func getUserPosts(completion: @escaping (Result<[Post], Error>) -> ())  {
        db.collection(DatabaseService.postsCollection).getDocuments { (snapshot, error) in
            if let error = error    {
                completion(.failure(error))
            }
                
            else if let snapshot = snapshot {

                let posts = snapshot.documents.map {Post($0.data())}
                completion(.success(posts))
            }
        }
    }
    
    func getPostPhotoURL(completion: @escaping (Result<String, Error>) -> ())  {
        guard let user = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.postsCollection).document(user.uid).getDocument { (snapshot, error) in
            if let error = error    {
                completion(.failure(error))
            }
                
            else if let snapshot = snapshot {
                
                let postURL = snapshot.get("photoURL") as? String
                completion(.success(postURL ?? ""))
            }
        }
    }
    
    func getUserAndCount(completion: @escaping (Result<Int, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.postsCollection).document(user.uid).getDocument { (snapshot, error) in
            if let error = error    {
                completion(.failure(error))
            }
            
            else if let snapshot = snapshot {
                let postCount = snapshot.get("numberOfPost") as? Int
                completion(.success(postCount ?? 0))
            }
        }
    }
    
    public func getProfileInfoForUser(completion: @escaping (Result<[String: Any], Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.postsCollection).document(user.uid).getDocument { (snapshot, error) in
            if let error = error    {
                completion(.failure(error))
            }
            else if let snapshot = snapshot {
                let profile = snapshot.data()
                completion(.success(profile ?? [String: Any]()))
            }
        }
    }
    
    public func updateDatabaseProfilePhoto(photoURL: String? = nil, completion: @escaping(Result<Bool, Error>) -> ())    {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.postsCollection)
            .document(user.uid).updateData(["photoURL" : photoURL ?? ""]) { (error) in
                if let error = error {
                  completion(.failure(error))
                } else {
                  completion(.success(true))
          }
        }
    }
    
    public func updateDatabaseDisplayName(displayName: String, completion: @escaping(Result<Bool, Error>) -> ())    {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.postsCollection)
            .document(user.uid).updateData(["createdBy" : displayName]) { (error) in
                if let error = error {
                  completion(.failure(error))
                } else {
                  completion(.success(true))
          }
        }
    }
    
}

