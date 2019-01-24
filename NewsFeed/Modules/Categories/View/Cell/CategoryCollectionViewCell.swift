//
//  CategoryCollectionViewCell.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var categoryTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.masksToBounds = false
        
        categoryTitleLabel.layer.cornerRadius = 10
        categoryTitleLabel.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        categoryTitleLabel.text = nil
        categoryImageView.image = nil
    }
}
