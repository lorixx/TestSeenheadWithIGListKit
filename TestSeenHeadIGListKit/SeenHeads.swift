//
//  SeenHeads.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 1/31/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import UIKit
import IGListKit

final class SeenHeads: NSObject, ListDiffable {
    var users: [TestUser] = []
    
    init(_ users: [TestUser]) {
        super.init()
        self.users = users
    }
    
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? SeenHeads else { return false }
        return users.count == object.users.count
    }
}

