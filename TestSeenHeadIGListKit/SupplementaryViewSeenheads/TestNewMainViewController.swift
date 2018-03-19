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
    
    public var userIDToTestSeenHeadView = [String : TestSeenHeadReusableView]()
    
    public func collectionViewLayout() -> TestMessagesNewCollectionViewLayout {
        return self.collectionView.collectionViewLayout as! TestMessagesNewCollectionViewLayout
    }
    
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
    
    func sectionController(_ sectionController: TestMessageSectionController, didTapSeenHead user: TestUser, elementKind kind: String) {
        let sectionIndex = messages.index(of: adapter.object(for: sectionController) as! TestMessage)!
        let oldMessages = TestMessagesDeepCopy(self.messages)
        
        // Update Data Model
        let testMessage = messages[sectionIndex]
        let index = testMessage.seenBy.index(of: user)
        testMessage.seenBy.remove(at: index!)
        messages.last!.seenBy.append(user)
        
        var deletes = [ String : IndexPath ]()
        var inserts = [ String : IndexPath ]()
        if sectionIndex == messages.count - 1 {
            // If it's the last section, then we update everything after `index`.
            for currentIndex in index!..<testMessage.seenBy.count {
                let kind = (TestSeenHeadSupplementaryViewType(rawValue:(currentIndex))?.string)!
                inserts[kind] = IndexPath.init(item: 0, section: sectionIndex)
                deletes[kind] = IndexPath.init(item: 0, section: sectionIndex)
            }
        } else {
            let insertKind = TestSeenHeadSupplementaryViewType(rawValue:(messages.last!.seenBy.count - 1))?.string
            deletes = [ kind : IndexPath.init(item: 0, section: sectionIndex) ]
            inserts = [ insertKind! : IndexPath.init(item: 0, section: messages.count - 1) ]
        }
        
        let collectionViewLayout = collectionView.collectionViewLayout as! TestMessagesNewCollectionViewLayout
        collectionViewLayout.prepareLayoutWith(deletes: deletes, inserts: inserts, oldMessages: oldMessages, newMessages: messages)
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
    
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout: TestMessagesNewCollectionViewLayout, uidOfSeenHeadAt indexPath: IndexPath) -> String {
        guard let testMessage = adapter.object(atSection: indexPath.section) as! TestMessage! else {
            assertionFailure()
            return ""
        }
        
        let seenHeadIndex = indexPath.item
        if seenHeadIndex >= testMessage.seenBy.count {
            return ""
        }

        return testMessage.seenBy[seenHeadIndex].name
    }
}

