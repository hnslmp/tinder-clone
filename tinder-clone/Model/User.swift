//
//  User.swift
//  tinder-clone
//
//  Created by Hansel Matthew on 05/06/22.
//

import Foundation
import UIKit

struct User {
    var name: String
    var age: Int
    let email: String
    let uid: String
    let profileImageUrl: String
    
    init(dictionary: [String:Any]){
        self.name = dictionary["fullname"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageUrl = dictionary["imageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
