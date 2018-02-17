//
//  ViewController.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 1/30/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import UIKit
import IGListKit

class MainViewController: UIViewController, ListAdapterDataSource {

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    lazy var collectionView : UICollectionView = {
        let layout = TestMessageCollectionViewLayout.init()
        layout.dataSource = self
        return UICollectionView.init(frame: .zero, collectionViewLayout:layout)
    }()
    
    private var viewModels: [ListDiffable] = []
    
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
        viewModels.removeAll()
        
        let user1 = TestUser.init("James", color: .black)
        let user2 = TestUser.init("Jason", color: .blue)
        let user3 = TestUser.init("Haley", color: .yellow)
        let users = [user1, user2, user3]
        
        let message1 = TestMessage.init("Hello, how's it going!", seenBy: [user1])
        let message2 = TestMessage.init("I am fine! Thank you", seenBy: [])
        let message3 = TestMessage.init("Any plan for the long weekend?", seenBy: [user2])
        let messages = [message1, message2, message3]
        
        for _ in 0..<15 {
            let isSeenhead = (arc4random_uniform(2) == 1)
            if isSeenhead {
                let userIndex = Int(arc4random_uniform(3))
                let user = users[userIndex]
                self.viewModels.append(TestUser.init(user.name, color: user.color))
            } else {
                let messageIndex = Int(arc4random_uniform(3))
                let message = messages[messageIndex]
                self.viewModels.append(TestMessage.init(message.text, seenBy: []))
            }
        }
    }

    // MARK: ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModels
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return SingleSectionController.init()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension MainViewController: ListSingleSectionControllerDelegate {
    func didSelect(_ sectionController: ListSingleSectionController, with object: Any) {
        // NB: After user taps on a normal message cell, we reset and regenerate a new set of data
        self.resetData()
        adapter.performUpdates(animated: true, completion: nil)
    }
}

extension MainViewController: TestMessageCollectionViewLayoutDataSource {
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout: TestMessageCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return adapter.sizeForItem(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout: TestMessageCollectionViewLayout, isSeenHeadAt indexPath: IndexPath) -> Bool {
        let object = viewModels[indexPath.section]
        return (object is TestUser)
    }
}
