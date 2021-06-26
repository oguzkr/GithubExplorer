//
//  User.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 24.06.2021.
//

import UIKit

struct User: Codable {

    let id: Int
    let displayName: String
    let email: String
    let avatarURL: String
    let token: String
}
