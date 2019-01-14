//
//  NewsDetailViewController.swift
//  NewsFeed
//
//  Created by Admin on 12/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {

    var presenter: NewsDetailInput?
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsAuthorLabel: UILabel!
    @IBOutlet weak var openNewsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(navigationItem: navigationItem)
        
        prepareInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.getStarted()
    }
    
    // MARK: Actions
    @IBAction func openNews(_ sender: UIButton) {
        presenter?.openNews()
    }
    
    private func configure(navigationItem: UINavigationItem) {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func prepareInterface() {
        openNewsButton.layer.cornerRadius = 5
    }
}

extension NewsDetailViewController: NewsDetailOutput {
    
    func configure(with news: News) {
        
        let df = DateFormatter()
        df.dateStyle = .short
        let dateString: String?
        
        if let date = news.publishedAt {
            dateString = df.string(from: date)
        } else {
            dateString = "none"
        }
        
        newsImageView.image = nil
        newsTitleLabel.text = news.title
        newsDescriptionLabel.text = news.description
        newsDateLabel.text = dateString
        newsAuthorLabel.text = news.author ?? "author"
    }
}
