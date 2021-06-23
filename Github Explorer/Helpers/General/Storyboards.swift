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
    static let MainScreen = Storyboard(name: "MainScreen", identifier: "mainscreen")
}
