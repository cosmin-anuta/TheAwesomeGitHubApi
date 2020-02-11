//
//  AsyncImageView.swift
//  TheSuperTest
//
//  Created by C: Cosmin Anuta on 11/02/2020.
//  Copyright © 2020 C: Cosmin Anuta. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AsyncImageView: UIImageView
{
    var url: URL?
    var activityIndicator = UIActivityIndicatorView()
    var request: DataRequest?
    
    func loadImage(fromUrl url: URL)
    {
        if url != self.url
        {
            showActivityIndicator()
            self.url = url
            
            request = Alamofire.request(url).responseData(queue: DispatchQueue.global())
            {[unowned self] (dataResponse) in
                if let data = dataResponse.data
                {
                    DispatchQueue.main.async
                    {
                        self.hideActivityIndicator()
                        self.image = UIImage(data: data, scale: 1)
                    }
                }
            }
        }
    }
    
    func cancelRequestInProgress()
    {
        if let request = request
        {
            request.cancel()
        }
    }

    func showActivityIndicator()
    {
        if activityIndicator.superview == nil
        {
            addActivityIndicator()
        }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator()
    {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func addActivityIndicator()
    {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        backgroundColor = UIColor.clear
    
        let viewDict = ["child": activityIndicator]
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[child]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[child]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        
        NSLayoutConstraint.activate(constraints)
    }
    

}
