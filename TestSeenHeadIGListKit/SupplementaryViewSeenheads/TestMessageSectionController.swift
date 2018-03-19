//
//  TestMessageSectionController.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 3/12/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import Foundation
import IGListKit

protocol TestMessageSectionControllerDelegate {
    func didTapSection(messageSectionController: TestMessageSectionController) -> Void
    
    func sectionController(_ sectionController: TestMessageSectionController, didTapSeenHead user: TestUser, elementKind kind: String) -> Void
}

final class TestMessageSectionController: ListSectionController {
    
    override init() {
        super.init()
        self.supplementaryViewSource = self
    }
    
    private var message: TestMessage?
    
    var delegate: TestMessageSectionControllerDelegate?
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else { return CGSize() }
        return CGSize(width: context.containerSize.width, height: CGFloat(TestSeenHeadUIMetrics.MessageHeight))
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: TestLabelCell.self,
                                                                for: self,
                                                                at: index) as? TestLabelCell else {
                                                                    fatalError()
        }
        cell.text = message!.text
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.message = object as? TestMessage
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.didTapSection(messageSectionController: self)
    }
}

extension TestMessageSectionController: ListSupplementaryViewSource {
    func supportedElementKinds() -> [String] {
        let numberOfSeenBys: Int = (message?.seenBy.count)!
        
        if numberOfSeenBys == 0 {
            return []
        }
        
        var results = [String]()
        for index in 0..<numberOfSeenBys {
            results.append((TestSeenHeadSupplementaryViewType(rawValue: index)?.string)!)
        }
        return results
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        let seenHeadSupplementaryView = (self.collectionContext?.dequeueReusableSupplementaryView(ofKind: elementKind, for: self, class: TestSeenHeadReusableView.self, at: index))! as! TestSeenHeadReusableView
        seenHeadSupplementaryView.elementKind = elementKind
        seenHeadSupplementaryView.indexPath = IndexPath.init(item: index, section: self.section)
        seenHeadSupplementaryView.delegate = self
        
        let index = TestSeenHeadIndex(from: elementKind)
        let user = (self.message?.seenBy[index])!
        seenHeadSupplementaryView.imageURL = user.url
        return seenHeadSupplementaryView
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: CGFloat(TestSeenHeadUIMetrics.SeenHeadWidth), height: CGFloat(TestSeenHeadUIMetrics.SeenHeadWidth))
    }
}

extension TestMessageSectionController: TestSeenHeadReusableViewDelegate {
    func seenHeadResuaableViewDidTap(_ seenHeadReusableView: TestSeenHeadReusableView) {
        let elementKind = seenHeadReusableView.elementKind
        let index = TestSeenHeadIndex(from: elementKind)
        let user = self.message?.seenBy[index]
        delegate?.sectionController(self, didTapSeenHead: user!, elementKind: elementKind)
    }
}
