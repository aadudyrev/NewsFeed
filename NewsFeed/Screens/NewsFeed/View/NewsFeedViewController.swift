//
//  NewsFeedViewController.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    var presenter: NewsFeedInput?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure(navigationItem: navigationItem)
        configure(searchController: searchController)
        configure(tableView: tableView)
        
        presenter?.getStarted()
    }
    
    // MARK: Actions
    @objc func refreshAction(_ sender: UIRefreshControl) {
        presenter?.update()
    }
    
    // MARK: Setup Views
    private func configure(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NewsFeedTableViewCell.nib, forCellReuseIdentifier: NewsFeedTableViewCell.name)
    }
    
    private func configure(navigationItem: UINavigationItem) {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshAction(_:)))
        navigationItem.rightBarButtonItem = refreshButton

        navigationItem.title = presenter?.title
        navigationItem.largeTitleDisplayMode = .always
        
        if presenter?.showSearchBar == true {
            definesPresentationContext = true
            searchController = UISearchController(searchResultsController: nil)
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    private func configure(searchController: UISearchController?) {
        searchController?.searchBar.delegate = self
        searchController?.dimsBackgroundDuringPresentation = false
    }
}

extension NewsFeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter?.selectItem(at: indexPath)
    }
}

extension NewsFeedViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.newsList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableViewCell.name, for: indexPath) as! NewsFeedTableViewCell
        
        if let news = presenter?.newsList[indexPath.row] {
            cell.leftImageView?.setImage(fromURL: news.urlToImage)
            cell.titleLabel?.text = news.title
            cell.descriptionLabel?.text = news.description
        }

        return cell
    }

}

extension NewsFeedViewController: NewsFeedOutput {
    
    var searchText: String? {
        get {
            return searchController?.searchBar.text
        }
    }
    
    func showAlert(with title: String?, message: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.presentAlert(with: title, and: message)
        }
    }
    
    func startRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.startAnimating()
        }
    }
    
    func endRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension NewsFeedViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.update()
    }
}
