//
//  AuthenticationSession.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthenticationSession {
    
    public func createNewUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
          if let error = error {
            completion(.failure(error))
          } else if let authDataResult = authDataResult {
            completion(.success(authDataResult))
          }
        }
    }
    
    public func loginExistingUser(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> ()) {
      Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
        if let error = error {
          completion(.failure(error))
        } else if let authDataResult = authDataResult {
          completion(.success(authDataResult))
        }
      }
    }
    
    public func signOutCurrentUser()    {
        do  {
            try Auth.auth().signOut()
        }
        catch   {
            print(error.localizedDescription)
        }
    }
}

