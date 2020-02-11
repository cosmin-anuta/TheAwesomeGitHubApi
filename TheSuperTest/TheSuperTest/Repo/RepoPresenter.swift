//
//  RepoPresenter.swift
//  TheSuperTest
//
//  Created by C: Cosmin Anuta on 11/02/2020.
//  Copyright © 2020 C: Cosmin Anuta. All rights reserved.
//

import Foundation
import Alamofire

enum RepoSortType: Int {
    case ByName = 0
    case ByStars
}

class RepoPresenter
{
    private let getReposUrl = "https://api.github.com/user/repos"
    private let maxNumberOfItemsInDataSource = 10
    private let acceptHeaderKey = "Accept"
    private let jsonHeaderValue = "application/json"
    private let authorizationHeaderKey = "Authorization"
    
    private var dataSource = [RepoData]()
    private var currentSortType = RepoSortType.ByName
    
    /**
    * Retrieve the list of repos associated with the logged in user
    * @param success - success callback to be executed in case of success
    * @param failure - failkure callback to be executed in case of error
    */
    func retrieveData(success: @escaping Success, failure: @escaping ErrorCompletion)
    {
        guard let token = NetworkManager.shared().accessToken
        else
        {
            failure(nil)
            return
        }
    
        var headers = [String : String]()
        headers[acceptHeaderKey] = jsonHeaderValue
        headers[authorizationHeaderKey] = "token \(token)"
        
        Alamofire.request(getReposUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON
        { [unowned self] response in
            switch (response.result)
            {
            case .success(let json):
                if let arrayOfRepos = json as? [[String: Any]]
                {
                    self.updateDataSource(withRepos: arrayOfRepos)
                    success()
                }
                else
                {
                    failure(nil)
                }
                break
            case .failure(let error):
                failure(error)
            }
        }
    }
    
    private func updateDataSource(withRepos repos: [[String: Any]])
    {
        let dataSourceSize = min(repos.count, maxNumberOfItemsInDataSource)
        let trimmedRepoList = repos[0 ..< dataSourceSize]
        var dataSource = [RepoData]()
        
        for repoDictionary in trimmedRepoList
        {
            dataSource.append(RepoData(dictionary: repoDictionary))
        }
        
        self.dataSource = sorted(repoList: dataSource, sortType: currentSortType)
    }
    
    /**
    * Returns the number of repos retrieved for the current user
    * @return Int - number of repos
    */
    func numberOfRepos() -> Int
    {
        return dataSource.count
    }
    
    func repoDataFor(index: Int) -> RepoData?
    {
        if (dataSource.count > index)
        {
            return dataSource[index]
        }
        return nil
    }
    
    /**
    * Sort the list of repos
    * @param sort - sort type to sort by
    */
    func sort(withType sort: RepoSortType)
    {
        currentSortType = sort
        dataSource = sorted(repoList: dataSource, sortType: currentSortType)
    }
    
    private func sorted(repoList: [RepoData], sortType: RepoSortType) -> [RepoData]
    {
        switch sortType {
        case .ByName:
            return repoList.sorted( by: {
                if $0.name == $1.name
                {
                    return $0.stars > $1.stars
                }
                return $0.name < $1.name
            })
        case .ByStars:
            return repoList.sorted( by: {
                if $0.stars == $1.stars
                {
                    return $0.name < $1.name
                }
                return $0.stars > $1.stars
            })
        }
    }
}
