//
//  TestMessagesNewCollectionViewLayout.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 3/11/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import Foundation
import UIKit


enum TestSeenHeadSupplementaryViewType: Int {
    case seenHead0
    case seenHead1
    case seenHead2
    case seenHead3
    case seenHead4
    case seenHead5
    case seenHead6
    case seenHead7
    case seenHead8
    case seenHead9
    
    var string: String {
        return String(describing: self)
    }
}

protocol TestMessagesNewCollectionViewLayoutDataSource  {
    
    // Ask the data source about the size of a cell.
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout:TestMessagesNewCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    
    // Ask the data source about the number of seenheads they might have for this indexPath.
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout:TestMessagesNewCollectionViewLayout, numberOfSeenHeads indexPath: IndexPath) -> Int
}


class TestMessagesNewCollectionViewLayout: UICollectionViewLayout {
    
    // index -> cell layout attributes
    private var indexPathToLayoutAttributes: [ IndexPath : UICollectionViewLayoutAttributes ] = [ : ]

    // index -> [ supplementary view type : UICollectionViewLayoutAttributes]
    private var indexPathToSupplementaryViewLayoutAttributes =  [ IndexPath : Dictionary<String, UICollectionViewLayoutAttributes> ]()
    
    // All the layout attributes
    private var allLayoutAttributes: [ UICollectionViewLayoutAttributes ] = []
    
    private var totalHeight: CGFloat = 0.0
    
    var dataSource: TestMessagesNewCollectionViewLayoutDataSource?
    
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

        let numberOfSections: Int = collectionViewDataSource.numberOfSections!(in: self.collectionView!)
        var maxHeight: CGFloat = 0.0
        var kindToSupplementaryViewAttributes = [String : UICollectionViewLayoutAttributes]()

        for section in 0..<numberOfSections {
            let currentIndexPath = IndexPath.init(item: 0, section: section)
            let size = layoutDataSource.collectionView(self.collectionView!, testMessageCollectionViewLayout: self, sizeForItemAt: currentIndexPath)
            let cellAttributes = UICollectionViewLayoutAttributes.init(forCellWith: currentIndexPath)
            cellAttributes.frame = CGRect.init(x: 0, y: maxHeight, width: size.width, height: size.height)
            allLayoutAttributes.append(cellAttributes)
            indexPathToLayoutAttributes[currentIndexPath] = cellAttributes
            maxHeight = cellAttributes.frame.maxY
            
            let numberOfSeenHeads = layoutDataSource.collectionView(self.collectionView!, testMessageCollectionViewLayout: self, numberOfSeenHeads: currentIndexPath)
            for seenHeadIndex in 0..<numberOfSeenHeads {
                let seenHeadSupplementaryViewKind = TestSeenHeadSupplementaryViewType(rawValue: seenHeadIndex)!.string
                let seenHeadSupplementaryViewAttributes = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind:seenHeadSupplementaryViewKind, with: currentIndexPath)
                seenHeadSupplementaryViewAttributes.frame =
                    CGRect.init(x: collectionView!.bounds.size.width - CGFloat(seenHeadIndex+1)*CGFloat(TestSeenHeadUIMetrics.SeenHeadWidth + 5.0),
                                y: cellAttributes.frame.maxY,
                                width: CGFloat(TestSeenHeadUIMetrics.SeenHeadWidth),
                                height: CGFloat(TestSeenHeadUIMetrics.SeenHeadWidth))
                allLayoutAttributes.append(seenHeadSupplementaryViewAttributes)
                maxHeight = seenHeadSupplementaryViewAttributes.frame.maxY
                kindToSupplementaryViewAttributes[seenHeadSupplementaryViewKind] = seenHeadSupplementaryViewAttributes
            }
            if numberOfSeenHeads > 0 {
                indexPathToSupplementaryViewLayoutAttributes[currentIndexPath] = kindToSupplementaryViewAttributes
            }
        }
        
        totalHeight = maxHeight
    }
    
    override var collectionViewContentSize: CGSize {
        if let collectionView = self.collectionView {
            return CGSize.init(width: collectionView.frame.size.width, height: max(collectionView.frame.size.height, totalHeight))
        } else {
            return CGSize.zero
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let layoutAttributes = indexPathToLayoutAttributes[indexPath] {
            return layoutAttributes
        } else {
            assertionFailure()
            return nil
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result: [UICollectionViewLayoutAttributes] = []
        
        for currentLayoutAttributes in allLayoutAttributes {
            if (rect.intersects(currentLayoutAttributes.frame)) {
                result.append(currentLayoutAttributes)
            }
        }
        return result.count > 0 ? result : nil
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let kindToAttributes = indexPathToSupplementaryViewLayoutAttributes[indexPath] else {
            return nil
        }
        
        return kindToAttributes[elementKind]
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
}
