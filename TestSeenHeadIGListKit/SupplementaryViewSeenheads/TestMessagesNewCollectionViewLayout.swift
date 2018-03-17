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

    // Ask the data source for the uid of the seenHead
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout:TestMessagesNewCollectionViewLayout, uidOfSeenHeadAt indexPath: IndexPath) -> String
}

class TestMessagesNewCollectionViewLayout: UICollectionViewLayout {
    
    // indexPath -> cell layout attributes
    private var indexPathToLayoutAttributes: [ IndexPath : UICollectionViewLayoutAttributes ] = [ : ]

    // indexPath -> [ supplementary view type : UICollectionViewLayoutAttributes]
    private var indexPathToSupplementaryViewLayoutAttributes =  [ IndexPath : Dictionary<String, UICollectionViewLayoutAttributes> ]()
    
    // All the layout attributes
    private var allLayoutAttributes: [ UICollectionViewLayoutAttributes ] = []
    
    private var totalHeight: CGFloat = 0.0
    
    private var correctedSeenHeadIndex = [ Dictionary<String, Int> ]()
    
    public func seenHeadIndexFrom(elementKind: String, section: Int) -> Int? {
        if let elementKindToSeenheadIndex: Dictionary<String, Int> = correctedSeenHeadIndex[section] {
            if let seenHeadIndex = elementKindToSeenheadIndex[elementKind] {
                return seenHeadIndex
            }
        }
        
        return nil
    }
    
    var dataSource: TestMessagesNewCollectionViewLayoutDataSource?
    
    var previousSeenHeadIdToAttributes = [ String : UICollectionViewLayoutAttributes ]()
    var currentSeenHeadIdToAttributes = [ String : UICollectionViewLayoutAttributes ]()
    
    override class var layoutAttributesClass: AnyClass {
        return TestSeenHeadCollectionViewLayoutAttributes.self
    }

    override func prepare() {
        super.prepare()
        
        allLayoutAttributes.removeAll()
        totalHeight = 0.0
        indexPathToSupplementaryViewLayoutAttributes.removeAll()
        indexPathToLayoutAttributes.removeAll()
        correctedSeenHeadIndex.removeAll()
        
        // Set previous to the current one
        previousSeenHeadIdToAttributes = currentSeenHeadIdToAttributes
        currentSeenHeadIdToAttributes.removeAll()
        
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

        for section in 0..<numberOfSections {
            var kindToSupplementaryViewAttributes = [String : UICollectionViewLayoutAttributes]()
            var kindToSeenheadIndex = [String : Int]()
            let currentIndexPath = IndexPath.init(item: 0, section: section)
            let size = layoutDataSource.collectionView(self.collectionView!, testMessageCollectionViewLayout: self, sizeForItemAt: currentIndexPath)
            let cellAttributes = UICollectionViewLayoutAttributes.init(forCellWith: currentIndexPath)
            cellAttributes.frame = CGRect.init(x: 0, y: maxHeight, width: size.width, height: size.height)
            allLayoutAttributes.append(cellAttributes)
            indexPathToLayoutAttributes[currentIndexPath] = cellAttributes
            maxHeight = cellAttributes.frame.maxY
            
            let numberOfSeenHeads = layoutDataSource.collectionView(self.collectionView!, testMessageCollectionViewLayout: self, numberOfSeenHeads: currentIndexPath)
            for seenHeadIndex in 0..<numberOfSeenHeads {
                var seenHeadSupplementaryViewKind = TestSeenHeadSupplementaryViewType(rawValue: seenHeadIndex)!.string
                let uid: String = (dataSource?.collectionView(self.collectionView!, testMessageCollectionViewLayout: self, uidOfSeenHeadAt: IndexPath.init(item: seenHeadIndex, section: section)))!
                if let oldAttributes = previousSeenHeadIdToAttributes[uid] {
                    if (oldAttributes.indexPath) == currentIndexPath {
                        // Reuse the previous supplementary kind, only if at the same indexPath location
                        seenHeadSupplementaryViewKind = oldAttributes.representedElementKind!
                    }
                }
                let seenHeadSupplementaryViewAttributes = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind:seenHeadSupplementaryViewKind, with: currentIndexPath)
                seenHeadSupplementaryViewAttributes.frame =
                    CGRect.init(x: collectionView!.bounds.size.width - CGFloat(seenHeadIndex+1)*CGFloat(TestSeenHeadUIMetrics.SeenHeadWidth + 5.0),
                                y: cellAttributes.frame.maxY,
                                width: CGFloat(TestSeenHeadUIMetrics.SeenHeadWidth),
                                height: CGFloat(TestSeenHeadUIMetrics.SeenHeadWidth))
                allLayoutAttributes.append(seenHeadSupplementaryViewAttributes)
                maxHeight = seenHeadSupplementaryViewAttributes.frame.maxY
                kindToSupplementaryViewAttributes[seenHeadSupplementaryViewKind] = seenHeadSupplementaryViewAttributes
                currentSeenHeadIdToAttributes[uid] = seenHeadSupplementaryViewAttributes
                kindToSeenheadIndex[seenHeadSupplementaryViewKind] = seenHeadIndex
            }
            
            correctedSeenHeadIndex.append(kindToSeenheadIndex)
            indexPathToSupplementaryViewLayoutAttributes[currentIndexPath] = kindToSupplementaryViewAttributes
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
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result: [UICollectionViewLayoutAttributes] = []
        
        for currentLayoutAttributes in allLayoutAttributes {
            if (rect.intersects(currentLayoutAttributes.frame)) {
                result.append(currentLayoutAttributes)
            }
        }
        return result.count > 0 ? result : nil
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let layoutAttributes = indexPathToLayoutAttributes[indexPath] {
            return layoutAttributes
        } else {
            assertionFailure()
            return nil
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let kindToAttributes = indexPathToSupplementaryViewLayoutAttributes[indexPath]
        let attributes: UICollectionViewLayoutAttributes? = kindToAttributes?[elementKind]
        if (attributes == nil) {
            // We need to return a valid attributes to UICollectionView, otherwise it will crash!!!
            return UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: elementKind, with: indexPath)
        } else {
            return attributes
        }
    }
    
    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        if let seenHeadIndex = seenHeadIndexFrom(elementKind: elementKind, section: elementIndexPath.section) {
//            let uid = dataSource?.collectionView(collectionView!, testMessageCollectionViewLayout: self, uidOfSeenHeadAt: IndexPath.init(item: seenHeadIndex, section: elementIndexPath.section))
//            if uid == "" {
//                return super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
//            }
//        } else {
//            // Weird
//            return super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
        //        }
        //
        if let seenHeadIndex = self.seenHeadIndexFrom(elementKind: elementKind, section: elementIndexPath.section) {
            let uid = dataSource?.collectionView(collectionView!, testMessageCollectionViewLayout: self, uidOfSeenHeadAt: IndexPath.init(item: seenHeadIndex, section: elementIndexPath.section))
            if uid == "" {
                return super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
            } else {
                // Use the previous attributes to this ID.
                return previousSeenHeadIdToAttributes[uid!]
            }
        }
        
        let attributes = super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
        return attributes
    }
}