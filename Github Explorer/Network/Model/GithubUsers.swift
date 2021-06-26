//
//  GithubUsers.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 24.06.2021.
//

import Foundation

// MARK: - GithubUsers
struct GithubUsers: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let login: String?
    let id: Int?
    let node_id: String?
    let avatar_url: String?
    let gravatarid: String?
    let url, htmlurl, followersurl: String?
    let followingurl, gistsurl, starredurl: String?
    let subscriptionsurl, organizationsurl, reposurl: String?
    let eventsurl: String?
    let receivedEventsurl: String?
    let type: String?
    let siteAdmin: Bool?
    let score: Int?
}
