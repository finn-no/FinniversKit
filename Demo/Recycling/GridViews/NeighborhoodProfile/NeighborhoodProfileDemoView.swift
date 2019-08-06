//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

final class NeighborhoodProfileDemoView: UIView {
    private lazy var view: NeighborhoodProfileView = {
        let view = NeighborhoodProfileView(withAutoLayout: true)
        view.delegate = self
        view.title = "Om nabolaget"
        view.buttonTitle = "Utforsk"
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor)
        ])
    }
}

// MARK: - NeighborhoodProfileViewDelegate

extension NeighborhoodProfileDemoView: NeighborhoodProfileViewDelegate {
    func neighborhoodProfileView(_ view: NeighborhoodProfileView, didSelectUrl url: URL?) {
        print("\(String(describing: url)) selected")
    }
}
