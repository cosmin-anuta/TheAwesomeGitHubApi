//
//  ViewController.swift
//  TheSuperTest
//
//  Created by C: Cosmin Anuta on 10/02/2020.
//  Copyright © 2020 C: Cosmin Anuta. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class LoginViewController: UIViewController
{
    private let loginPresenter = LoginPresenter()
    private let repoScreenSegueIdentifier = "ShowRepoScreen"
    
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var webView: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        webView.delegate = self
        if let authorizationUrlRequest = loginPresenter.generateAuthorizationURLRequest()
        {
            webView.loadRequest(authorizationUrlRequest)
        }
    }

    func showActivityIndicator()
    {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        webView.isHidden = true
    }
    
    func hideActivityIndicator()
    {
        activityIndicator.isHidden = true
        webView.isHidden = false
    }
    
    func showError(errorMessage: String)
    {
        let alert = UIAlertController(title: "Oops", message: "Something went wrong!\n\(errorMessage)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func navigateToRepoScreen()
    {
        performSegue(withIdentifier: repoScreenSegueIdentifier, sender: self)
    }
}

extension LoginViewController: UIWebViewDelegate
{
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        showError(errorMessage: error.localizedDescription)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        let url = webView.request?.url
        if (loginPresenter.shouldRetrieveAccessToken(fromUrl: url))
        {
            showActivityIndicator()
            loginPresenter.retrieveAccessToken(fromUrl: url, success:
            { [unowned self] in
                self.navigateToRepoScreen()
                self.hideActivityIndicator()
            })
            { [unowned self] (error) in
                self.showError(errorMessage: error?.localizedDescription ?? "")
            }
        }
    }
}
