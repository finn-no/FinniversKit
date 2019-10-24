//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class DynamicShadowView: UIView {
    static let maxShadowRadius: CGFloat = 3

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Shadow

    public func updateShadow(using scrollView: UIScrollView) {
        let contentFrame = CGRect(
            x: -scrollView.contentOffset.x,
            y: scrollView.frame.minY - scrollView.contentOffset.y - scrollView.contentInset.top,
            width: scrollView.contentSize.width,
            height: scrollView.contentSize.height + scrollView.contentInset.top
        )

        let intersection = contentFrame.intersection(frame)
        layer.shadowRadius = min(intersection.height * 0.2, DynamicShadowView.maxShadowRadius)
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 0
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
    }
}
