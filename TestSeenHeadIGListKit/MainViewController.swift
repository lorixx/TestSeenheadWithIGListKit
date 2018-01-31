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
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var viewModels: [ ListDiffable ] = []
    
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
        
        for _ in 0..<35 {
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
        if object is TestMessage {
            let configureBlock = { (item: Any, cell: UICollectionViewCell) in
                guard let cell = cell as? TestLabelCell, let message = item as? TestMessage else { return }
                cell.text = message.text
            }
            
            let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
                guard let context = context else { return CGSize() }
                return CGSize(width: context.containerSize.width, height: 50)
            }

            return ListSingleSectionController.init(cellClass: TestLabelCell.self, configureBlock:configureBlock, sizeBlock: sizeBlock)
        } else if object is TestUser {
            let configureBlock = { (item: Any, cell: UICollectionViewCell) in
                guard let cell = cell as? TestSeenHeadCell, let user = item as? TestUser else { return }
                cell.color = user.color
            }
            
            let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
                return CGSize(width: 10, height: 10)
            }
            
            return ListSingleSectionController.init(cellClass: TestSeenHeadCell.self, configureBlock:configureBlock, sizeBlock: sizeBlock)
        } else {
            print("Incorrect data")
            return ListSectionController.init()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

