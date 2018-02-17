//
//  TestSeenHeadUIMetrics.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 2/17/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import Foundation
import IGListKit

class TestSeenHeadUIMetrics {
    static let MessageHeight: Float = 50.0
    static let SeenHeadWidth: Float = 20.0
    
    static func GenerateViewModels() -> [ListDiffable] {
        var viewModels = [ListDiffable]()
        
        let user1 = TestUser.init("James", color: .black, url: URL.init(string: "https://scontent.fsnc1-1.fna.fbcdn.net/v/t1.0-9/10320492_10203683472786098_1796114260594468235_n.jpg?_nc_log=1&oh=41f2f60202d30f0e67ee943daf735926&oe=5B04CC02"))
        let user2 = TestUser.init("Jason", color: .blue, url: URL.init(string: "https://scontent.fsnc1-1.fna.fbcdn.net/v/t1.0-9/1919160_181586074524_4464118_n.jpg?_nc_log=1&oh=2b06001ada20780caa4a3ed0aa7ad21a&oe=5B0A846A") )
        let user3 = TestUser.init("Haley", color: .yellow, url: URL.init(string: "https://scontent.fsnc1-1.fna.fbcdn.net/v/t1.0-9/19875516_835220939960203_2905082744148610128_n.jpg?_nc_log=1&oh=60a5224668ded1cd518d0a11349ea345&oe=5B2390E4"))
        let users = [user1, user2, user3]
        
        let message1 = TestMessage.init("Hello, how's it going!", seenBy: [user1])
        let message2 = TestMessage.init("I am fine! Thank you", seenBy: [])
        let message3 = TestMessage.init("Any plan for the long weekend?", seenBy: [user2])
        let message4 = TestMessage.init("Thinking to go snowboarding @ Tahoe!", seenBy: [user3])
        let messages = [message1, message2, message3, message4]
        
        for _ in 0..<15 {
            let isSeenhead = (arc4random_uniform(2) == 1)
            if isSeenhead {
                let userIndex = Int(arc4random_uniform(UInt32(users.count)))
                let user = users[userIndex]
                viewModels.append(TestUser.init(user.name, color: user.color, url: user.url))
            } else {
                let messageIndex = Int(arc4random_uniform(UInt32(messages.count)))
                let message = messages[messageIndex]
                viewModels.append(TestMessage.init(message.text, seenBy: []))
            }
        }
        
        return viewModels
    }
}
