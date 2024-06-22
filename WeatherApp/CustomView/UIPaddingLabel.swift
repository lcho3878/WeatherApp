//
//  UIPaddingLabel.swift
//  WeatherApp
//
//  Created by 이찬호 on 6/22/24.
//

import UIKit

class UIPaddingLabel: UILabel{
    var topInset: CGFloat = 0
    var bottomInset: CGFloat = 0
    var leftInset: CGFloat = 0
    var rightInset: CGFloat = 0
    
    init (edgeInsets: UIEdgeInsets) {
        super.init(frame: .zero)
        topInset = edgeInsets.top
        bottomInset = edgeInsets.bottom
        leftInset = edgeInsets.left
        rightInset = edgeInsets.right
        clipsToBounds = true
        layer.cornerRadius = 8
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
    
    override var bounds: CGRect {
        didSet { preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset) }
    }
}
