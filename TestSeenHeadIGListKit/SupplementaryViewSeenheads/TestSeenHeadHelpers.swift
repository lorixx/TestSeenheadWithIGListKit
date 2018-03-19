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

func TestMessagesDeepCopy(_ fromMessages: [TestMessage]) -> [TestMessage] {
    var result = [TestMessage]()
    for message in fromMessages {
        var seenBys = [TestUser]()
        for user in message.seenBy {
            seenBys.append(TestUser.init(user.name, color: user.color, url: user.url))
        }
        result.append(TestMessage.init(message.text, seenBy: seenBys))
    }
    return result
}
