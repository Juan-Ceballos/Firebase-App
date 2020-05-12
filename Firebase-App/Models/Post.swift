//
//  Post.swift
//  Firebase-App
//
//  Created by Juan Ceballos on 5/5/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import Foundation
import Firebase

struct Post {
    let photoURL: String
    let postDate: Timestamp
    let postedBy: String
    let postId = UUID().uuidString
    let userId: String
}

extension Post {
    init(_ dictionary: [String: Any]) {
        self.photoURL = dictionary["photoURL"] as? String ?? "no photoURL"
        self.postDate = dictionary["datePosted"] as? Timestamp ?? Timestamp(date: Date())
        self.postedBy = dictionary["createdBy"] as? String ?? "no id"
        self.userId = dictionary["userId"] as? String ?? "no Id"
    }
}
