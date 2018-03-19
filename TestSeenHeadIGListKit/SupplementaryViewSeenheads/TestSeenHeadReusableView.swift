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

protocol TestSeenHeadReusableViewDelegate {
    func seenHeadResuaableViewDidTap(_ seenHeadReusableView: TestSeenHeadReusableView)
}

// A resuable view that will be used as a supplementary view for seenhead.
class TestSeenHeadReusableView: UICollectionReusableView {
    private let imageView: UIImageView = UIImageView.init(frame: .zero)
    
    var delegate: TestSeenHeadReusableViewDelegate?
    
    var elementKind: String = ""
    
    var indexPath: IndexPath?
    
    private var layoutAttributes: UICollectionViewLayoutAttributes?
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
    override var description: String {
        return super.description + " layoutAttributes: \(String(describing: self.layoutAttributes))"
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
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        self.layoutAttributes = layoutAttributes
    }
    
    @objc func didTap(){
        delegate?.seenHeadResuaableViewDidTap(self)
    }
}
