//
//  RepoTableViewCell.swift
//  TheSuperTest
//
//  Created by C: Cosmin Anuta on 11/02/2020.
//  Copyright © 2020 C: Cosmin Anuta. All rights reserved.
//

import Foundation
import UIKit

class RepoTableViewCell: UITableViewCell
{
    @IBOutlet weak var avatarImageView: AsyncImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    
    func setData(repoData: RepoData)
    {
        nameLabel.text = repoData.name
        ratingsLabel.text = "Stars: \(repoData.stars)"
        
        if let url = repoData.imageUrl
        {
            avatarImageView.loadImage(fromUrl: url)
        }
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        avatarImageView.cancelRequestInProgress()
    }
}
