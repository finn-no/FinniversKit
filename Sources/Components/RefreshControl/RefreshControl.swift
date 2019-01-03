//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class RefreshControl: UIRefreshControl {
    private let defaultPullDistance: CGFloat = 100
    private lazy var loadingIndicatorView = LoadingIndicatorView(withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard !isRefreshing else {
            return
        }

        let pullDistance = superview.flatMap({ $0.bounds.height / 5 }) ?? defaultPullDistance
        let distance = max(0.0, -frame.origin.y)
        let progress = min(max(distance, 0.0), pullDistance) / pullDistance

        loadingIndicatorView.progress = progress

        if distance >= pullDistance {
            beginRefreshing()
        }
    }

    // MARK: - Setup

    private func setup() {
        loadingIndicatorView.backgroundColor = .white

        addTarget(self, action: #selector(handleValueChange), for: .valueChanged)
        addSubview(loadingIndicatorView)

        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalToConstant: .largeSpacing),
            loadingIndicatorView.heightAnchor.constraint(equalToConstant: .largeSpacing)
        ])
    }

    // MARK: - Animations

    public override func beginRefreshing() {
        guard !isRefreshing else { return }

        super.beginRefreshing()
        loadingIndicatorView.startAnimating()
    }

    public override func endRefreshing() {
        guard isRefreshing else { return }

        super.endRefreshing()
        loadingIndicatorView.stopAnimating()
    }

    @objc private func handleValueChange() {
        loadingIndicatorView.startAnimating()
    }
}
