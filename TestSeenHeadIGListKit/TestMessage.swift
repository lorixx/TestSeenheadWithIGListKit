//
//  TestMessage.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 1/30/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import Foundation
import IGListKit

class TestMessage: NSObject, ListDiffable {
    var text: String = ""
    var seenBy: [TestUser] = []
    let uuid = UUID.init()
    
    init(_ text: String, seenBy: [TestUser]) {
        super.init()
        self.text = text
        self.seenBy = seenBy
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return uuid as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? TestMessage else { return false }
        return text == object.text && seenBy.count == object.seenBy.count
    }
}
