//
//  TestLabelCell.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 1/30/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import UIKit

class TestLabelCell: UICollectionViewCell {
    
    private var textLabel = UILabel()
    
    public var text = "" {
        didSet {
            textLabel.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel.numberOfLines = 1
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.textColor = UIColor.brown
        textLabel.textAlignment = .right
        contentView.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.bounds.size
        textLabel.frame = CGRect(x: 10, y: (size.height - textLabel.font.lineHeight)/2, width: size.width - 20, height: textLabel.font.lineHeight)
    }
}
