//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ScrollViewController: UIViewController, UIScrollViewDelegate {
    private(set) lazy var topShadowView = ShadowView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topShadowView)
        NSLayoutConstraint.activate([
            topShadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topShadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topShadowView.topAnchor.constraint(equalTo: view.topAnchor, constant: -44),
        ])
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topShadowView.update(with: scrollView)
    }
}
