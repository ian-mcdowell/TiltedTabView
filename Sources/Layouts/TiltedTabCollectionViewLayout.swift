//
//  TiltedTabCollectionViewLayout.swift
//  TiltedTabView
//
//  Copyright © 2017 Ian McDowell. All rights reserved.
//

import UIKit

class TiltedTabCollectionViewLayout: UICollectionViewLayout {
    
    weak var delegate: UICollectionViewDelegate?
    weak var dataSource: UICollectionViewDataSource?
    
    /// Set by the view controller when user adds a tab.
    /// When a cell appears, if its index path was equal to this, the animation will differ.
    var addingIndexPath: IndexPath?
    
    /// Set by the view controller when user removes a tab.
    /// When a cell disappears, if its index path was equal to this, the animation will differ.
    var removingIndexPath: IndexPath?
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
