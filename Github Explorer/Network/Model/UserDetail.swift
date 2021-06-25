//
//  UserDetail.swift
//  Github Explorer
//
//  Created by Oğuz Karatoruk on 25.06.2021.
//

import Foundation

struct UserDetail: Codable{
    let login: String?
    let id: Int?
    let node_id: String?
    let avatar_url: String?
    let gravatar_id: String?
    let url, html_url, followers_url: String?
    let following_url, gists_url, starred_url: String?
    let subscriptions_url, organizations_url, repos_url: String?
    let events_url: String?
    let receivedEvents_url: String?
    let type: String?
    let siteAdmin: Bool?
    let name, blog, location, created_at, updated_at: String?
    let public_repos, public_gists, followers, following: Int?
}
