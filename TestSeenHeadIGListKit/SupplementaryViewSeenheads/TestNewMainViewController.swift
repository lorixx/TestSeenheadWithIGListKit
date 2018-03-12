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
        // did tap on the section
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
}







