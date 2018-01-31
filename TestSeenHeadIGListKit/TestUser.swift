//
//  TestUser.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 1/30/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import UIKit
import IGListKit

class TestUser: NSObject, ListDiffable {
    
    var name: String = ""
    var color: UIColor = UIColor.black
    let uuid = UUID.init()
    
    init(_ name: String, color: UIColor) {
        super.init()
        self.name = name
        self.color = color
    }
    
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return uuid as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? TestUser else { return false }
        return name == object.name
    }
}

