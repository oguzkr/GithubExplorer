//
//  Storyboards.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 23.06.2021.
//

import Foundation

struct Storyboard: Codable {
    var name = String()
    var identifier = String()
}

class Storyboards {
    static let LoginScreen = Storyboard(name: "Main", identifier: "loginscreen")
    static let ProfileScreen = Storyboard(name: "Profile", identifier: "profile")
}
