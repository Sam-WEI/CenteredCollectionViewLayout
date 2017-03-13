//
//  CenteredCollectionViewLayout.swift
//  CenteredCollectionViewLayout
//
//  Created by WeiShengkun on 3/13/17.
//  Copyright © 2017 WeiShengkun. All rights reserved.
//

import UIKit

protocol CenteredCollectionViewLayoutDelegate {
    func cellWidthRange() -> Range<CGFloat>
    func cellSpacingRange() -> Range<CGFloat>
}


class CenteredCollectionViewLayout: UICollectionViewLayout {
    
    var delegate: CenteredCollectionViewLayoutDelegate?
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var cv: UICollectionView {
        return collectionView!
    }

    private var contentHight: CGFloat {
        return cv.frame.height - cv.contentInset.top - cv.contentInset.bottom
    }
    
    private var contentWidth: CGFloat = 0
    
    private var minCellSpacing: CGFloat {
        return delegate?.cellSpacingRange().lowerBound ?? 2
    }
    
    private var maxCellSpacing: CGFloat {
        return delegate?.cellSpacingRange().upperBound ?? 10
    }
    
    private var minCellWidth: CGFloat {
        return delegate?.cellWidthRange().lowerBound ?? 10
    }
    
    private var maxCellWidth: CGFloat {
        return delegate?.cellWidthRange().upperBound ?? CGFloat.greatestFiniteMagnitude
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHight)
    }
    
    override func prepare() {
        cache.removeAll()
        let count = CGFloat(cv.numberOfItems(inSection: 0))
        
        guard count > 0 else {
            return
        }
        
        let frameWidth = cv.frame.width - cv.contentInset.left - cv.contentInset.right
        
        
        var maxWidthSum = count * maxCellWidth
        var minWidthSum = count * minCellWidth
        var maxSpacingSum = (count - 1) * maxCellSpacing
        var minSpacingSum = (count - 1) * minCellSpacing
        
        let finalCellWidth, finalCellSpacing: CGFloat
        
        if maxWidthSum + maxSpacingSum <= frameWidth {
            finalCellWidth = maxCellWidth
            finalCellSpacing = maxCellSpacing
        }
        else if maxWidthSum <= frameWidth {
            finalCellWidth = maxCellWidth
            let cellSpacingNeeded = count > 1 ? (frameWidth - maxWidthSum) / (count - 1) : 0
            finalCellSpacing = max(cellSpacingNeeded, minCellSpacing)
        }
        else if minWidthSum + minSpacingSum <= frameWidth {
            finalCellSpacing = minCellSpacing
            let remainingWidth = frameWidth - minSpacingSum * (count - 1)
            finalCellWidth = remainingWidth / count
        }
        else {
            finalCellSpacing = minCellSpacing
            finalCellWidth = minCellWidth
        }
        
        contentWidth = count * finalCellWidth + (count - 1) * finalCellSpacing
        
        if Int(count) % 2 == 0 {
            
        }
        
        
        
        
    }
    
}
