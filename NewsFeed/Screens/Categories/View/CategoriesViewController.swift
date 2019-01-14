//
//  CategoriesViewController.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    var presenter: CategoriesInput?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(navigationItem: navigationItem)
        configure(collectionView: collectionView)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func configure(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CategoryCollectionViewCell.nib, forCellWithReuseIdentifier: CategoryCollectionViewCell.name)
    }
    
    private func configure(navigationItem: UINavigationItem) {
        navigationItem.title = presenter?.title
    }
}

extension CategoriesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.getCategoriesList().count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.name, for: indexPath) as! CategoryCollectionViewCell
        
        if let categoryModel = presenter?.getCategoriesList()[indexPath.row] {
            cell.categoryTitleLabel.text = categoryModel.title
            cell.categoryImageView.image = UIImage(named: categoryModel.imageName!)
        }

        return cell
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        presenter?.selectItem(at: indexPath)
    }
}

extension CategoriesViewController: CategoriesOutput {
    
}
