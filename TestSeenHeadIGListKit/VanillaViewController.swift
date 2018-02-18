//
//  TestSeenheadViewController.swift
//  Romantidea
//
//  Created by Zhisheng Huang on 1/27/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import UIKit

enum ViewModel {
    case message(TestMessage)
    case seenHead(TestUser)
}

class VanillaViewController: UIViewController {
    
    fileprivate let cellReuseIdentifier = "cellReuseIdentifier"
    fileprivate let seenHeadCellReuseIdentifier = "seenHeadCellReuseIdentifier"
    fileprivate let seenHeadSupplementaryViewKind = "seenHeadSupplementaryViewKind"
    fileprivate let seenHeadSupplementaryViewIdentifier = "seenHeadSupplementaryViewIdentifier"
    
    private var collectionView: UICollectionView?
    
    private var messages: [TestMessage] = []
    
    private var viewModels: [ViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resetData()
        
        if let collectionView = self.collectionView {
            collectionView.backgroundColor = UIColor.white
            collectionView.register(TestLabelCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
            collectionView.register(TestSeenHeadCell.self, forCellWithReuseIdentifier: seenHeadCellReuseIdentifier)
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
        }
    }
    
    override func loadView() {
        let testMessageCollectionViewLayout: TestMessageCollectionViewLayout = TestMessageCollectionViewLayout()
        testMessageCollectionViewLayout.dataSource = self
        
        self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: testMessageCollectionViewLayout)
        
        view = self.collectionView
    }
    
    // MARK - Private
    
    fileprivate func resetData() {
        
        self.viewModels.removeAll()
        
        let user1 = TestUser.init("James", color: .black)
        let user2 = TestUser.init("Jason", color: .blue)
        let user3 = TestUser.init("Haley", color: .yellow)
        let users = [user1, user2, user3]
        
        let message1 = TestMessage.init("Hello, how's it going!", seenBy: [user1])
        let message2 = TestMessage.init("I am fine! Thank you", seenBy: [])
        let message3 = TestMessage.init("Any plan for the long weekend?", seenBy: [user2])
        self.messages = [message1, message2, message3]
        
        for _ in 0..<15 {
            let isSeenhead = (arc4random_uniform(2) == 1)
            
            if isSeenhead {
                let userIndex = Int(arc4random_uniform(3))
                let user = users[userIndex]
                self.viewModels.append(ViewModel.seenHead(user))
            } else {
                let messageIndex = Int(arc4random_uniform(3))
                let message = self.messages[messageIndex]
                self.viewModels.append(ViewModel.message(message))
            }
        }
    }
}

extension VanillaViewController: TestMessageCollectionViewLayoutDataSource {
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout: TestMessageCollectionViewLayout, isSeenHeadAt indexPath: IndexPath) -> Bool {
        switch self.viewModels[indexPath.item] {
        case .message:
            return false
        case .seenHead:
            return true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, testMessageCollectionViewLayout collectionViewLayout: TestMessageCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.viewModels[indexPath.item] {
        case .message:
            return CGSize(width:collectionView.bounds.size.width, height:50)
        case .seenHead:
            return CGSize(width:10, height:10)
        }
    }
}

extension VanillaViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.viewModels[indexPath.item] {
        case let .message(message):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! TestLabelCell
            cell.text = message.text
            return cell
        case let .seenHead(user):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.seenHeadCellReuseIdentifier, for: indexPath) as! TestSeenHeadCell
            cell.imageURL = user.url
            return cell
        }
    }
}

extension VanillaViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if isSeenHead(at: index) {
            let viewModel = self.viewModels.remove(at: index)
            self.viewModels.append(viewModel)
            collectionView.moveItem(at: IndexPath.init(item: index, section: 0), to: IndexPath.init(item: self.viewModels.endIndex-1, section: 0))
        } else {
            self.resetData()
            self.collectionView!.reloadData()
        }
    }
    
    func isSeenHead(at index:Int) -> Bool {
        switch self.viewModels[index] {
        case .message:
            return false
        case .seenHead:
            return true
        }
    }
}

