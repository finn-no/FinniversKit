//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class LoadingIndicatorViewDemoView: UIView {
    private lazy var loadingIndicatorView = LoadingIndicatorView(withAutoLayout: true)
    private lazy var delayedLoadingIndicatorView = LoadingIndicatorView(withAutoLayout: true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(loadingIndicatorView)
        addSubview(delayedLoadingIndicatorView)

        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60),
            loadingIndicatorView.widthAnchor.constraint(equalToConstant: 40),
            loadingIndicatorView.heightAnchor.constraint(equalToConstant: 40),

            delayedLoadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            delayedLoadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 60),
            delayedLoadingIndicatorView.widthAnchor.constraint(equalToConstant: 40),
            delayedLoadingIndicatorView.heightAnchor.constraint(equalToConstant: 40)
        ])

        loadingIndicatorView.startAnimating()
        delayedLoadingIndicatorView.startAnimating(after: 2.0)
    }
}
