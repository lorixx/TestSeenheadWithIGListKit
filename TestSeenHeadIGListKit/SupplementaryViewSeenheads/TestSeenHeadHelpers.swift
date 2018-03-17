//
//  TestSeenHeadHelpers.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 3/17/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import Foundation

func TestSeenHeadIndex(from seenHeadType: String) -> Int {
    return Int(seenHeadType.dropFirst("seenHead".count))!
}
