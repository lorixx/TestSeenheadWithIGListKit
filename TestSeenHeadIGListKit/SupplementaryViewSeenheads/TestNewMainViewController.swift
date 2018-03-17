//
//  TestNewMainViewController.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 3/12/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import UIKit
import IGListKit

class TestNewMainViewController: UIViewController, ListAdapterDataSource {
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = TestMessagesNewCollectionViewLayout.init()
        layout.dataSource = self
        return UICollectionView.init(frame: .zero, collectionViewLayout:layout)
    }()
    
    private var messages: [TestMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetData()
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.white
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    fileprivate func resetData() {
        messages.removeAll()
        messages = TestSeenHeadUIMetrics.GenerateMessages()
    }

    // MARK: ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return messages
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = TestMessageSectionController.init()
        sectionController.delegate = self
        return sectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension TestNewMainViewController: TestMessageSectionControllerDelegate {
    func didTapSection(messageSectionController: TestMessageSectionController) {
        resetData()
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    func sectionController(_ sectionController: TestMessageSectionController, didTapSeenHead user: TestUser) {
        let sectionIndex = messages.index(of: adapter.object(for: sectionController) as! TestMessage)!
        let testMessage = messages[sectionIndex]
        let index = testMessage.seenBy.index(of: user)
        
//        let invalidationContext = UICollectionViewLayoutInvalidationContext.init()
//
//        // Invalidate all the supplementary views in that IndexPath.
//        for currentIndex in 0..<testMessage.seenBy.count {
//            let elementKind = TestSeenHeadSupplementaryViewType(rawValue: currentIndex)?.string
//            invalidationContext.invalidateSupplementaryElements(ofKind: elementKind!, at: [IndexPath.init(item: 0, section: sectionIndex)])
//        }

        testMessage.seenBy.remove(at: index!)
        messages.last!.seenBy.append(user)
        
//        collectionView.performBatchUpdates({() -> Void in
//            collectionView.collectionViewLayout.invalidateLayout(with: invalidationContext)
//        }, completion: nil)
        
        collectionView.layoutIfNeeded()
        adapter.performUpdates(animated: true, completion: nil)
    }
}

extension TestNewMainViewController: TestMessagesNewCollectionViewLayoutDataSource {
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout: TestMessagesNewCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return adapter.sizeForItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout: TestMessagesNewCollectionViewLayout, numberOfSeenHeads indexPath: IndexPath) -> Int {
        guard let testMessage = adapter.object(atSection: indexPath.section) as! TestMessage! else {
            return 0
        }
        
        return testMessage.seenBy.count
    }
    
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout: TestMessagesNewCollectionViewLayout, uidOfSeenHeadAt indexPath: IndexPath, supplementaryViewKind: String) -> String {
        guard let testMessage = adapter.object(atSection: indexPath.section) as! TestMessage! else {
            assertionFailure()
            return ""
        }
        
        let foundIndex = TestSeenHeadIndex(from: supplementaryViewKind)
        if foundIndex >= testMessage.seenBy.count {
            return ""
        }

        return testMessage.seenBy[foundIndex].name
    }
}







