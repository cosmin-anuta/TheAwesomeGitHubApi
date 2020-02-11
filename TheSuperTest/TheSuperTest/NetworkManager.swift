//
//  File.swift
//  TheSuperTest
//
//  Created by C: Cosmin Anuta on 11/02/2020.
//  Copyright © 2020 C: Cosmin Anuta. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager
{
    private init() {}
    
    private static var uniqueInstance: NetworkManager = { return NetworkManager() }()

    class func shared() -> NetworkManager
    {
        return uniqueInstance
    }
    
    // AccessToken used for calls that require authentication
    var accessToken: String?
}
