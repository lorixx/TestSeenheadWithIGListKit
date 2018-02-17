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
        viewModels = TestSeenHeadUIMetrics.GenerateViewModels()
    }

    // MARK: ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return viewModels
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let sectionController = SingleSectionController.init()
        sectionController.delegate = self
        return sectionController
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

extension MainViewController: SingleSectionControllerDelegate {
    func didTapSection(singleSectionController: SingleSectionController) {
        let obj = viewModels.remove(at: singleSectionController.section)
        viewModels.append(obj)
        adapter.performUpdates(animated: true, completion: nil)
    }
}
