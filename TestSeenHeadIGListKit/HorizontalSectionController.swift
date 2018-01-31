//
//  HorizontalSectionController.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 1/31/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import IGListKit
import UIKit

final class HorizontalSectionController: ListSectionController, ListAdapterDataSource {
    
    private var seenHeads: SeenHeads?
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 10)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: EmbeddedCollectionViewCell.self,
                                                                for: self,
                                                                at: index) as? EmbeddedCollectionViewCell else {
                                                                    fatalError()
        }
        adapter.collectionView = cell.collectionView
        return cell
    }
    
    override func didUpdate(to object: Any) {
        seenHeads = object as? SeenHeads
    }
    
    // MARK: ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return seenHeads!.users
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let configureBlock = { (item: Any, cell: UICollectionViewCell) in
            guard let cell = cell as? TestSeenHeadCell, let user = item as? TestUser else { return }
            cell.color = user.color
        }
        
        let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
            return CGSize(width: 10, height: 10)
        }
        
        return ListSingleSectionController.init(cellClass: TestSeenHeadCell.self, configureBlock:configureBlock, sizeBlock: sizeBlock)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
