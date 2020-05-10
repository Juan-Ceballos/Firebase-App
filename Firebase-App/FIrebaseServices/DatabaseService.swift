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
    
    public func createDatabaseUser(authDataResult: AuthDataResult,
                                   completion: @escaping (Result<Bool, Error>) -> ())  {
        guard let email = authDataResult.user.email else {
            return
        }
        db.collection(DatabaseService.usersCollection)
            .document(authDataResult.user.uid)
            .setData(["email" : email,
                      "createdDate": Timestamp(date: Date()),
                      "userId": authDataResult.user.uid,
                      "displayName": email,
                      "photoURL": "",
                      "numberOfPost" : 0 ]) { (error) in
                        
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(true))
                        }
        }
    }
    
    public func updateDatabaseProfilePhoto(numberOfPost: Int? = nil, displayName: String? = nil, photoURL: String? = nil, completion: @escaping(Result<Bool, Error>) -> ())    {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.usersCollection)
            .document(user.uid).updateData(["photoURL" : photoURL ?? "", "displayName" : displayName ?? "", "numberOfPost" : numberOfPost ?? 0]) { (error) in
                if let error = error {
                  completion(.failure(error))
                } else {
                  completion(.success(true))
          }
        }
    }
    
    func getUserAndCount(completion: @escaping (Result<Int, Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.usersCollection).document(user.uid).getDocument { (snapshot, error) in
            if let error = error    {
                completion(.failure(error))
            }
            
            else if let snapshot = snapshot {
                let postCount = snapshot.get("numberOfPost") as? Int
                completion(.success(postCount ?? 0))
            }
        }
    }
    
    //refactor display name
    public func updateDatabaseDisplayName(photoURL: String, completion: @escaping(Result<Bool, Error>) -> ())    {
        guard let user = Auth.auth().currentUser else { return }
        db.collection(DatabaseService.usersCollection)
          .document(user.uid).updateData(["photoURL" : photoURL]) { (error) in
                if let error = error {
                  completion(.failure(error))
                } else {
                  completion(.success(true))
          }
        }
    }
    
    public func getProfileInfoForUser(completion: @escaping (Result<[String: Any], Error>) -> ()) {
        guard let user = Auth.auth().currentUser else {return}
        db.collection(DatabaseService.usersCollection).document(user.uid).getDocument { (snapshot, error) in
            if let error = error    {
                completion(.failure(error))
            }
            else if let snapshot = snapshot {
                let profile = snapshot.data()
                completion(.success(profile ?? [String: Any]()))
            }
        }
    }
    
}

