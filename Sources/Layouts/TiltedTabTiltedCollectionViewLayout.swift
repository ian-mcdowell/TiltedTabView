//
//  TiltedTabTiltedCollectionViewLayout.swift
//  TiltedTabView
//
//  Copyright © 2017 Ian McDowell. All rights reserved.
//

import UIKit

class TiltedTabTiltedCollectionViewLayout: TiltedTabCollectionViewLayout {

    private var layoutAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var contentHeight: CGFloat = 0
    
    private let minimumAngle: CGFloat = -30
    private let maximumAngle: CGFloat = -80
    private let standardDepth: CGFloat = 200
    private let distanceBetweenItems: CGFloat = 110
    
    override func prepare() {
        super.prepare()
        
        layoutAttributes = [:]
        contentHeight = 0
        
        guard let collectionView = collectionView else {
            return
        }
        
        let scaleFactor: CGFloat = 0.8
        let itemWidth = collectionView.bounds.width * scaleFactor
        let itemHeight = collectionView.bounds.height * scaleFactor
        
        for section in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            
            for item in 0..<itemCount {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attributes.frame = CGRect(
                    x: (collectionView.bounds.width - itemWidth) / 2,
                    y: CGFloat(item) * distanceBetweenItems,
                    width: itemWidth,
                    height: itemHeight
                )
                
                let angle: CGFloat = {
                    let distanceFromTop = attributes.frame.midY + (-1 * collectionView.bounds.midY)
                    let distanceRatio = distanceFromTop / itemHeight
                    let normalisedDistanceRatio = (max(-1, min(1, distanceRatio)) + 1) / 2
                    return minimumAngle + (normalisedDistanceRatio * (maximumAngle - minimumAngle))
                }()
                
                let rotation = CATransform3DMakeRotation(CGFloat.pi * angle / 180, 1, 0, 0)
                let downTranslation = CATransform3DMakeTranslation(0, 0, -standardDepth)
                let upTranslation = CATransform3DMakeTranslation(0, 0, standardDepth)
                var scale = CATransform3DIdentity
                scale.m34 = -1 / 1200
                let perspective = CATransform3DConcat(CATransform3DConcat(downTranslation, scale), upTranslation)
                
                attributes.transform3D = CATransform3DConcat(rotation, perspective)
                attributes.zIndex = item
                
                layoutAttributes[indexPath] = attributes
                contentHeight += distanceBetweenItems
            }
            
            contentHeight += itemHeight
        }
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
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else { return nil }
        if self.addingIndexPath == itemIndexPath {
            attributes.transform3D = CATransform3DScale(CATransform3DTranslate(attributes.transform3D, 0, attributes.bounds.height, 0), 0.8, 0.8, 0.8)
        }
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else { return nil }
        if self.removingIndexPath == itemIndexPath {
            attributes.transform3D = CATransform3DTranslate(attributes.transform3D, -attributes.bounds.width, 0, 0)
        }
        return attributes
    }
    
    override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attributes = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        return attributes
    }
    
}
