//
//  User.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/14/22.
//

import Foundation


class User {
    let name: String
    let email: String
    let password: String
    let username: String
    
    init(name: String, email: String, password: String, username: String) {
        self.name = name
        self.email = email
        self.password = password
        self.username = username
    }
}
