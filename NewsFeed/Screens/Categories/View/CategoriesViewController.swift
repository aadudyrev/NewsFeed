//
//  CategoriesViewController.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    lazy var presenter: CategoriesInput = {
        let pres = CategoriesPresenter(output: self)
        return pres
    }()
    
    var categories = [CategoryModel]()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(collectionView: collectionView)
        
        categories = presenter.getCategoriesList()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func configure(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(CategoryCollectionViewCell.nib, forCellWithReuseIdentifier: CategoryCollectionViewCell.name)
    }
    
}

extension CategoriesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.name, for: indexPath) as! CategoryCollectionViewCell
        
        let categoryModel = categories[indexPath.row]
        
        cell.categoryTitleLabel.text = categoryModel.title
        cell.categoryImageView.image = UIImage(named: categoryModel.imageName!)
        
        return cell
    }
}

extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        presenter.selectItem(at: indexPath)
    }
}

extension CategoriesViewController: CategoriesOutput {
    
}
