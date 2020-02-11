//
//  LoginPresenter.swift
//  TheSuperTest
//
//  Created by C: Cosmin Anuta on 11/02/2020.
//  Copyright © 2020 C: Cosmin Anuta. All rights reserved.
//

import Foundation
import Alamofire

typealias Success = () -> Void
typealias ErrorCompletion = (Error?) -> Void

class LoginPresenter
{
    private let clientId = "4a3050274303b866bd08"
    private let clientSecret = "9136a82ab4ab6c1a9ca0a77da5be6f4e274b789d"
    private let redirectUrl = "https://github.com/"
    
    private let authorizationUrl = "https://github.com/login/oauth/authorize"
    private let accessTokenUrl = "https://github.com/login/oauth/access_token"
    
    private let clientIdParameter = "client_id"
    private let clientSecretParameter = "client_secret"
    private let codeParameter = "code"
    private let accessTokenParam = "access_token"
    
    private let acceptHeaderKey = "Accept"
    private let jsonHeaderValue = "application/json"
    
    /**
    * Login page can be found at this URL
    * @return URLRequest - url that display the github login page
    */
    public func generateAuthorizationURLRequest() -> URLRequest?
    {
        guard let url = URL(string: "\(authorizationUrl)?\(clientIdParameter)=\(clientId)") else { return nil }
            
        return URLRequest(url: url)
    }
    
    /**
    * After user enters credentials, github will redirect us to the redirrect page and append the "code" parameter.
    * @param fromUrl - url to verify if contains "code" param or not
    * @return Bool - True if "code" param has been found in the url
    */
    public func shouldRetrieveAccessToken(fromUrl url: URL?) -> Bool
    {
        guard let url = url else {return false}
        return url.absoluteString.contains("\(redirectUrl)?\(codeParameter)")
    }
    
    //Retrieve the "code" parameter from the url after user entered credentials
    private func getLoginCode(fromUrl url: URL?) -> String?
    {
        guard let urlString = url?.absoluteString else {return nil}
        guard let urlComponents = URLComponents(string: urlString) else { return nil}
        guard let queryItem = urlComponents.queryItems?.first(where: { $0.name == codeParameter }) else { return nil}
        guard let code = queryItem.value else { return nil}
        
        return code
    }
    
    /**
    * Retrieve the access token from an url that contains "code" parameter
    * @param fromUrl - url that may contain "code" param
    * @param success - success callback to be executed in case of success
    * @param failure - failure callback to be executed in case of error
    */
    //
    func retrieveAccessToken(fromUrl url: URL?, success: @escaping Success, failure: @escaping ErrorCompletion)
    {
        let parameters = [clientSecretParameter : clientSecret,
                          clientIdParameter : clientId,
                          codeParameter : getLoginCode(fromUrl: url)]
        
        var headers = [String : String]()
        headers[acceptHeaderKey] = jsonHeaderValue
        
        Alamofire.request(accessTokenUrl, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON
            { [unowned self] response in
                switch (response.result)
                {
                case .success(let json):
                    if let dictionary = json as? Dictionary<String, String>, let accessToken = dictionary[self.accessTokenParam]
                    {
                        NetworkManager.shared().accessToken = accessToken
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
}
