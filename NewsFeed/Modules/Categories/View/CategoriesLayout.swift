//
//  CategoriesLayout.swift
//  NewsFeed
//
//  Created by Admin on 11/01/2019.
//  Copyright © 2019 aadudyrev. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    
    let contentInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    let cellVerticalSpacing: CGFloat = 16
    let cellHorizontalSpacing: CGFloat = 16
    
    let numberOfColumns = 2
    
    func horizontalInsets() -> CGFloat {
        return contentInsets.left + contentInsets.right + cellHorizontalSpacing * CGFloat(numberOfColumns - 1)
    }
    
    func verticalInsets() -> CGFloat {
        return contentInsets.top + contentInsets.bottom
    }
}

class CategoriesLayout: UICollectionViewLayout {
    
    private let constants = Constants()
    private var sectionlayoutInfo = [[UICollectionViewLayoutAttributes]]()
    private var contentSize: CGSize = .zero
    
    override var collectionViewContentSize: CGSize {
        get {
            return contentSize
        }
        set {
            
        }
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        sectionlayoutInfo.removeAll()
        
        var x = constants.contentInsets.left
        var y = constants.contentInsets.top
        
        let itemWidth: CGFloat = (collectionView.bounds.width - constants.horizontalInsets()) / CGFloat(constants.numberOfColumns)
        let itemHeight = itemWidth
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let sectionsCount = collectionView.numberOfSections
        
        for section in 0..<sectionsCount {
            
            if section != 0 {
                x = constants.contentInsets.left
                y += itemSize.height + constants.cellVerticalSpacing
            }
            
            var layoutInfo = [UICollectionViewLayoutAttributes]()
            
            let itemsCount = collectionView.numberOfItems(inSection: section)
            
            for row in 0..<itemsCount {
                
                if row % constants.numberOfColumns == 0, row != 0 {
                    x = constants.contentInsets.left
                    y += itemSize.height + constants.cellVerticalSpacing
                }
                
                let frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
                let indexPath = IndexPath(row: row, section: section)
                let layoutAtrb = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                layoutAtrb.frame = frame
                
                layoutInfo.append(layoutAtrb)
                
                x += itemSize.width + constants.cellHorizontalSpacing
            }
            
            sectionlayoutInfo.append(layoutInfo)
        }
        
        let lastLayoutAtrb = sectionlayoutInfo.last?.last
        let tmpHeight = (lastLayoutAtrb?.frame.maxY ?? y) + constants.contentInsets.bottom
        
        contentSize = CGSize(width: collectionView.bounds.width, height: tmpHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var intersectsLayouts = [UICollectionViewLayoutAttributes]()
        
        for sLayout in sectionlayoutInfo {
            for layout in sLayout {
                if rect.intersects(layout.frame) {
                    intersectsLayouts.append(layout)
                }
            }
        }
        
        return intersectsLayouts
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return sectionlayoutInfo[indexPath.section][indexPath.row]
    }
    
}
