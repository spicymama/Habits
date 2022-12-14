//
//  User.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/14/22.
//

import Foundation


class User {
    let id: String
    let email: String
    let password: String
    
    init(id: String, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}
