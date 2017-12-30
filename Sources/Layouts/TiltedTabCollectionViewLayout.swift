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
    
    func collectionViewDidScroll(_ collectionView: UICollectionView) {}
}
