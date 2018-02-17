//
//  TestSeenHeadCell.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 1/30/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import UIKit
import AlamofireImage

class TestSeenHeadCell: UICollectionViewCell {
    
    private let imageView: UIImageView = UIImageView.init(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.contentView.bounds
    }
        
    public var imageURL: URL? {
        didSet {
            let seenHeadWidth = CGFloat(TestSeenHeadUIMetrics.SeenHeadWidth)
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: CGSize(width: seenHeadWidth, height: seenHeadWidth),
                radius: seenHeadWidth/2.0
            )
            
            imageView.af_setImage(withURL: imageURL!, placeholderImage: nil, filter: filter)
        }
    }
}
