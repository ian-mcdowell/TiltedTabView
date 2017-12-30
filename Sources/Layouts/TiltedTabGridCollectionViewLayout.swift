//
//  TiltedTabGridCollectionViewLayout.swift
//  TiltedTabView
//
//  Copyright © 2017 Ian McDowell. All rights reserved.
//

import UIKit

class TiltedTabGridCollectionViewLayout: TiltedTabCollectionViewLayout {
    
    private let maxItemsPerRow: Int = 3
    private let minSpacingBetweenItems: CGFloat = 35
    
    private var layoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var contentHeight: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        
        layoutAttributes = [:]
        
        guard let collectionView = collectionView else {
            return
        }
        
        var currentHeight: CGFloat = 0
        
        // Subtract spacing on left/right
        let horizontalSpacing = minSpacingBetweenItems
        let verticalSpacing = minSpacingBetweenItems
        let rowUsableWidth = collectionView.bounds.width - horizontalSpacing
        let maxItemWidth = collectionView.bounds.width * 0.8
        
        for section in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            if itemCount == 0 { continue }
            let numberOfItemsPerRow = min(itemCount, maxItemsPerRow)
            let numberOfRows = Int(ceil(Double(itemCount) / Double(numberOfItemsPerRow)))
            
            let itemWidth = min(rowUsableWidth / CGFloat(numberOfItemsPerRow) - horizontalSpacing, maxItemWidth)
            // Item size should match aspect ratio of collection view's bounds
            let itemHeight = (collectionView.bounds.height / collectionView.bounds.width) * itemWidth
            
            for item in 0..<itemCount {
                let row = Int(ceil(Double(item + 1) / Double(numberOfItemsPerRow))) - 1
                let positionInRow = item % numberOfItemsPerRow
                
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                let xPosition: CGFloat
                if itemWidth == maxItemWidth {
                    // Case where there is one item in section, and it is the max width, it should be centered horizontally.
                    xPosition = (collectionView.bounds.width - itemWidth) / 2
                } else {
                    // Otherwise (most cases), it should be positionInRow * itemWidth, plus padding
                    xPosition = horizontalSpacing + (CGFloat(positionInRow) * itemWidth) + (CGFloat(positionInRow) * horizontalSpacing)
                }
                attributes.frame = CGRect(
                    x: xPosition,
                    y: verticalSpacing + (CGFloat(row) * itemHeight) + (CGFloat(row) * verticalSpacing),
                    width: itemWidth,
                    height: itemHeight
                )
                
                layoutAttributes[indexPath] = attributes
            }

            currentHeight += (itemHeight * CGFloat(numberOfRows)) + (verticalSpacing * CGFloat(numberOfRows))
        }
        
        // Add some spacing onto the end for bottom padding
        contentHeight = currentHeight + verticalSpacing
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.frame.size.width ?? 0, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.values.filter { rect.intersects($0.frame) }
    }
}
