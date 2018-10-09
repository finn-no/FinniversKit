//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class LoadingIndicatorViewDemoView: UIView {
    private lazy var loadingIndicatorView: LoadingIndicatorView = {
        let view = LoadingIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(loadingIndicatorView)

        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalToConstant: 40),
            loadingIndicatorView.heightAnchor.constraint(equalToConstant: 40)
        ])

        loadingIndicatorView.startAnimating()
    }
}
