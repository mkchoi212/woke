//
//  ArticleViewLayout.swift
//  woke
//
//  Created by Mike Choi on 11/2/18.
//  Copyright © 2018 Mike Choi. All rights reserved.
//

import UIKit

class ArticleViewLayout: CollectionViewLayout {
    
    
    override func prepare() {
        numberOfColumns = 1
        
        if cache.isEmpty {
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            var xOffset = [CGFloat]()
            
            for column in 0 ..< numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth )
            }
            
            let column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                let indexPath = NSIndexPath(item: item, section: 0)
                let width = columnWidth - cellPadding * 2
                let itemHeight = delegate.collectionView(collectionView!, heightForItemAtIndexPath: indexPath, withWidth:width)
                
                let height = itemHeight
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = CollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
                attributes.itemHeight = itemHeight
                attributes.frame = insetFrame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }

}
