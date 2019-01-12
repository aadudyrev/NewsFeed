//
//  NewsFeedViewController.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {
    
    lazy var presenter: NewsFeedInput = {
        let pres = NewsFeedPresenter(output: self, category: category!)
        return pres
    }()
    
    private var newsList: [News]?
    var category: CategoryModel?
    
    @IBOutlet var tableView: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        let refreshC = UIRefreshControl(frame: .zero)
        refreshC.addTarget(self, action: #selector(refreshControlChangedValue(_:)), for: .valueChanged)
        return refreshC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure(tableView: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.getStarted()
    }
    
    // MARK: Actions
    @objc func refreshControlChangedValue(_ sender: UIRefreshControl) {
        presenter.update()
    }
    
    func configure(tableView: UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NewsFeedTableViewCell.nib, forCellReuseIdentifier: NewsFeedTableViewCell.name)
        
        tableView.addSubview(refreshControl)
    }

}

extension NewsFeedViewController: UITableViewDelegate {

}

extension NewsFeedViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedTableViewCell.name, for: indexPath) as! NewsFeedTableViewCell
        
        if let news = newsList?[indexPath.row] {
            cell.titleLabel?.text = news.title
            cell.descriptionLabel?.text = news.description
        }

        return cell
    }
    
}

extension NewsFeedViewController: NewsFeedOutput {
    func showSearchBar() {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.showsCancelButton = true
        searchBar.placeholder = "search please"
        navigationItem.titleView = searchBar
    }
    
    func showAlert(with title: String?, message: String?) {
        
        if Thread.current.isMainThread == false {
            DispatchQueue.main.async { [weak self] in
                self?.showAlert(with: title, message: message)
            }
            return
        }
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .destructive) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(alertAction)
        
        present(alertVC, animated: true)
    }
    
    func startRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.beginRefreshing()
        }
    }
    
    func endRefresh() {
        DispatchQueue.main.async { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.newsList = self?.presenter.getNews()
            self?.tableView.reloadData()
        }
    }
}
