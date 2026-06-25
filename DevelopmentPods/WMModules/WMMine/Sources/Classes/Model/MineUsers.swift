//
//  MineUsers.swift
//  WMMine
//
//  Created by Condy on 2020/12/28.
//

import SmartCodable

struct MineUsers: SmartCodableX {
    var login: String? //": "yangKJ",
    var userId: Int? //": 17396101,
    var node_id: String? //": "MDQ6VXNlcjE3Mzk2MTAx",
    var avatar_url: URL? //": "https://avatars.githubusercontent.com/u/17396101?v=4",
    var gravatar_id: String? //": "",
    var url: String? //": "https://api.github.com/users/yangKJ",
    var html_url: String? //": "https://github.com/yangKJ",
    var followers_url: String? //": "https://api.github.com/users/yangKJ/followers",
    var following_url: String? //": "https://api.github.com/users/yangKJ/following{/other_user}",
    var gists_url: String? //": "https://api.github.com/users/yangKJ/gists{/gist_id}",
    var starred_url: String? //": "https://api.github.com/users/yangKJ/starred{/owner}{/repo}",
    var subscriptions_url: String? //": "https://api.github.com/users/yangKJ/subscriptions",
    var organizations_url: String? //": "https://api.github.com/users/yangKJ/orgs",
    var repos_url: String? //": "https://api.github.com/users/yangKJ/repos",
    var events_url: String? //": "https://api.github.com/users/yangKJ/events{/privacy}",
    var received_events_url: String? //": "https://api.github.com/users/yangKJ/received_events",
    var type: String? //": "User",
    var site_admin: Bool? //": false,
    var name: String? //": "yangKJ",
    var company: String? //": "None",
    var blog: String? //": "https://github.com/yangKJ",
    var location: String? //": "Chengdu",
    var email: String? //": null,
    var hireable: Bool? //": true,
    var bio: String? //": "🧸 A drummer is also an ios engineer and loves rock music.",
    var twitter_username: String? //": null,
    var public_repos: Int? //": 46,
    var public_gists: Int? //": 0,
    var followers: Int? //": 269,
    var following: Int? //": 1,
    var created_at: String? //": "2016-02-22T01:51:01Z",
    var updated_at: String? //": "2023-05-28T11:40:39Z"
    var starNote: String?
    
    static func mappingForKey() -> [SmartKeyTransformer]? {
        return [
            CodingKeys.userId <--- ["id"],
        ]
    }
}
