//
//  CenteredCollectionViewLayout.swift
//  CenteredCollectionViewLayout
//
//  Created by WeiShengkun on 3/13/17.
//  Copyright © 2017 WeiShengkun. All rights reserved.
//

import UIKit

@objc protocol CenteredCollectionViewLayoutDelegate {
    @objc optional func minimumCellWidth() -> CGFloat
    @objc optional func maximumCellWidth() -> CGFloat
    @objc optional func cellSpacing() -> CGFloat
}


class CenteredCollectionViewLayout: UICollectionViewLayout {
    
    var delegate: CenteredCollectionViewLayoutDelegate?
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var cv: UICollectionView {
        return collectionView!
    }
    
    private var viewPortWidth: CGFloat {
        return cv.bounds.width - cv.contentInset.left - cv.contentInset.right
    }
    
    private var viewPortHeight: CGFloat {
        return cv.bounds.height - cv.contentInset.top - cv.contentInset.bottom
    }

    private var contentHeight: CGFloat {
        return self.viewPortHeight
    }
    
    private var contentWidth: CGFloat = 0
    
    private var cellSpacing: CGFloat {
        return delegate?.cellSpacing?() ?? 2
    }

    
    private var minCellWidth: CGFloat {
        return delegate?.minimumCellWidth?() ?? 0
    }
    
    private var maxCellWidth: CGFloat {
        return delegate?.maximumCellWidth?() ?? CGFloat.greatestFiniteMagnitude
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        cache.removeAll()
        let count = CGFloat(cv.numberOfItems(inSection: 0))
        
        guard count > 0 else {
            return
        }
        
        
        let maxWidthSum = count * maxCellWidth
        let minWidthSum = count * minCellWidth
        let spacingSum = (count - 1) * cellSpacing
        
        let finalCellWidth: CGFloat
        
        if maxWidthSum + spacingSum <= viewPortWidth {
            finalCellWidth = maxCellWidth
        }
        else if minWidthSum + spacingSum <= viewPortWidth {
            let remainingWidth = viewPortWidth - spacingSum
            finalCellWidth = remainingWidth / count
        }
        else {
            finalCellWidth = minCellWidth
        }
        
        contentWidth = count * finalCellWidth + (count - 1) * cellSpacing
        
        var left: CGFloat
        
        if contentWidth > viewPortWidth {
            left = cv.contentInset.left
        } else {
            let midX = cv.contentInset.left + viewPortWidth / 2
            left = midX - contentWidth / 2
        }
        
        let top = cv.contentInset.top
        
        for i in 0..<Int(count) {
            let attr = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            let frame = CGRect(x: left, y: top, width: finalCellWidth, height: contentHeight)
            attr.frame = frame
            cache.append(attr)
            left += finalCellWidth + cellSpacing
        }
        
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        return cache
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
}
