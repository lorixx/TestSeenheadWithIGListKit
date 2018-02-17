//
//  SingleSectionController.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 2/17/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import Foundation
import IGListKit

protocol SingleSectionControllerDelegate {
    func didTapSection(singleSectionController: SingleSectionController) -> Void
}

final class SingleSectionController: ListSectionController {
    
    private var object: Any?
    
    var delegate: SingleSectionControllerDelegate?
    
    override func sizeForItem(at index: Int) -> CGSize {
        if object! is TestMessage {
            guard let context = collectionContext else { return CGSize() }
            return CGSize(width: context.containerSize.width, height: 50)
        } else if object! is TestUser {
            return CGSize(width: 10, height: 10)
        } else {
            return CGSize.zero
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if object! is TestMessage {
            guard let cell = collectionContext?.dequeueReusableCell(of: TestLabelCell.self,
                                                                    for: self,
                                                                    at: index) as? TestLabelCell else {
                                                                        fatalError()
            }
            let message = object as! TestMessage
            cell.text = message.text
            return cell
        } else if object! is TestUser {
            guard let cell = collectionContext?.dequeueReusableCell(of: TestSeenHeadCell.self,
                                                                    for: self,
                                                                    at: index) as? TestSeenHeadCell else {
                                                                        fatalError()
            }
            let user = object as! TestUser
            cell.color = user.color
            return cell
        } else {
            fatalError()
            return UICollectionViewCell.init(frame: .zero)
        }
    }
    
    override func didUpdate(to object: Any) {
        self.object = object
    }
    
    override func didSelectItem(at index: Int) {
        delegate?.didTapSection(singleSectionController: self)
    }
}
