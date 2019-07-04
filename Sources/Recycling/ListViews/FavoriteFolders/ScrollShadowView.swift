//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with scrollView: UIScrollView) {
        let contentFrame = CGRect(
            x: -scrollView.contentOffset.x,
            y: scrollView.frame.minY - scrollView.contentOffset.y - scrollView.contentInset.top,
            width: scrollView.contentSize.width,
            height: scrollView.contentSize.height + scrollView.contentInset.top
        )

        let intersection = contentFrame.intersection(frame)
        layer.shadowRadius = min(intersection.height * 0.2, 3)
    }

    private func setup() {
        backgroundColor = .white
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 0
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
    }
}
