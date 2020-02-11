//
//  File.swift
//  TheSuperTest
//
//  Created by C: Cosmin Anuta on 11/02/2020.
//  Copyright © 2020 C: Cosmin Anuta. All rights reserved.
//

import Foundation

struct RepoData
{
    private let nameKey = "name"
    private let imageKey = "avatar_url"
    private let starsgazersKey = "stargazers_count"
    private let ownerKey = "owner"
    
    var name: String = ""
    var stars: Int = 0
    var imageUrl: URL?
    
    init(dictionary: [String: Any])
    {
        if let repoName = dictionary[nameKey] as? String
        {
            name = repoName
        }
        
        if let ownerDictionary = dictionary[ownerKey] as? [String: Any]
        {
            if let avatarUrl = ownerDictionary[imageKey] as? String
            {
                imageUrl = URL(string: avatarUrl)
            }
        }
        
        if let stargazersCount = dictionary[starsgazersKey] as? Int
        {
            stars = stargazersCount
        }
    }
}
