//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

public class DetailCalloutDemoView: UIView, Demoable {

    private lazy var calloutViews: [DetailCalloutView] = {
        DetailCalloutView.Direction.allCases.map { (direction) -> DetailCalloutView in
            let view = DetailCalloutView(direction: direction)
            view.configure(withText: "Nyhet!")
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: calloutViews)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .center
        view.spacing = .spacingXL
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
