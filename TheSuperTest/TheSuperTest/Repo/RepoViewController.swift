//
//  RepoViewController.swift
//  TheSuperTest
//
//  Created by C: Cosmin Anuta on 11/02/2020.
//  Copyright © 2020 C: Cosmin Anuta. All rights reserved.
//

import Foundation
import UIKit

class RepoViewController: UIViewController
{
    private var repoPresenter = RepoPresenter()
    private var refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource = self

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        refresh()
    }
    
    @IBAction func sortDidChange(_ sender: UISegmentedControl)
    {
        if let sortType = RepoSortType(rawValue: sender.selectedSegmentIndex)
        {
            repoPresenter.sort(withType: sortType)
            tableView.reloadData()
        }
    }
    
    @objc func refresh()
    {
        repoPresenter.retrieveData(success:
        { [unowned self] in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
        { (error) in
            
        }
    }
    
    
}

extension RepoViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return repoPresenter.numberOfRepos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        
        if let cell = cell as? RepoTableViewCell, let repoData = repoPresenter.repoDataFor(index: indexPath.row)
        {
            cell.setData(repoData: repoData)
        }
        return cell
    }
}
