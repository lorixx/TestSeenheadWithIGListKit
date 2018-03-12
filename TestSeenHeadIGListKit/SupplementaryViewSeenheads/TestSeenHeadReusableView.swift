//
//  TestSeenHeadReusableView.swift
//  TestSeenHeadIGListKit
//
//  Created by Zhisheng Huang on 3/11/18.
//  Copyright © 2018 Zhisheng Huang. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

// A resuable view that will be used as a supplementary view for seenhead.
class TestSeenHeadReusableView: UICollectionReusableView {
    private let imageView: UIImageView = UIImageView.init(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
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
