//
//  TestMessagesCollectionViewLayout.swift
//
//  Created by Zhisheng Huang on 1/28/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import UIKit

protocol TestMessageCollectionViewLayoutDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout:TestMessageCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout:TestMessageCollectionViewLayout, isSeenHeadAt indexPath: IndexPath) -> Bool
}

class TestMessageCollectionViewLayout: UICollectionViewLayout {
    
    private var indexToLayoutAttributes: [ Int : UICollectionViewLayoutAttributes ] = [ : ]
    
    private var layoutAttributes: [ UICollectionViewLayoutAttributes ] = []
    
    private var totalHeight: CGFloat = 0.0
    
    private let seenheadMargin: CGFloat = 5.0
    
    var dataSource: TestMessageCollectionViewLayoutDataSource?
    
    override func prepare() {
        
        super.prepare()
        
        guard let collectionViewDataSource = self.collectionView?.dataSource else {
            print("CollectionView data source is not set")
            return
        }
        
        guard let layoutDataSource = self.dataSource else {
            print("layout data source is not set")
            return
        }
        
        let numberOfItems: Int = collectionViewDataSource.numberOfSections!(in: self.collectionView!)
        var maxHeight: CGFloat = 0.0
        var isPrevSeenHead = false
        
        for index in 0..<numberOfItems {
            let newIndexPath = IndexPath.init(item: 0, section: index)
            
            let size = layoutDataSource.collectionView(self.collectionView!, testMessageCollectionViewLayout: self, sizeForItemAt: newIndexPath)
            let newAttributes = UICollectionViewLayoutAttributes.init(forCellWith: newIndexPath)
            let isSeenhead = layoutDataSource.collectionView(self.collectionView!, testMessageCollectionViewLayout: self, isSeenHeadAt: newIndexPath)
            
            if isSeenhead {
                if isPrevSeenHead {
                    // Append horizontally next to the previous seenhead
                    let previousSeenHeadAttributes = self.layoutAttributes.last!
                    newAttributes.frame = CGRect.init(x: previousSeenHeadAttributes.frame.minX - seenheadMargin - size.width, y: previousSeenHeadAttributes.frame.minY, width: size.width, height: size.height)
                } else {
                    // Layout the first seenhead
                    newAttributes.frame = CGRect.init(x: collectionView!.bounds.size.width - seenheadMargin - size.width, y: maxHeight, width: size.width, height: size.height)
                    isPrevSeenHead = true
                }
            } else {
                // Layout Cell normally
                newAttributes.frame = CGRect.init(x: 0, y: maxHeight, width: size.width, height: size.height)
                isPrevSeenHead = false
            }
            
            maxHeight = newAttributes.frame.maxY
            
            indexToLayoutAttributes[index] = newAttributes
            layoutAttributes.append(newAttributes)
        }
        
        self.totalHeight = maxHeight
    }
    
    override var collectionViewContentSize: CGSize {
        if let collectionView = self.collectionView {
            return CGSize.init(width: collectionView.frame.size.width, height: max(collectionView.frame.size.height, totalHeight))
        } else {
            return CGSize.zero
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let layoutAttributes = indexToLayoutAttributes[indexPath.item] {
            return layoutAttributes
        } else {
            assertionFailure()
            return nil
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result: [UICollectionViewLayoutAttributes] = []
        
        for currentLayoutAttributes in layoutAttributes {
            if (rect.intersects(currentLayoutAttributes.frame)) {
                result.append(currentLayoutAttributes)
            }
        }
        return result.count > 0 ? result : nil
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
}

