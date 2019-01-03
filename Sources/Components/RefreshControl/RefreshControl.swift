//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol RefreshControlDelegate: AnyObject {
    func refreshControlDidBeginRefreshing(_ refreshControl: RefreshControl)
}

public class RefreshControl: UIRefreshControl {
    public weak var delegate: RefreshControlDelegate?

    private let defaultPullDistance: CGFloat = 100
    private var isAnimating = false
    private lazy var loadingIndicatorView = LoadingIndicatorView(withAutoLayout: true)
    private lazy var contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .white
        return view
    }()

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

        if isAnimating && frame.origin.y == 0 {
            stopAnimatingLoadingIndicator()
        }

        guard !isAnimating else {
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
        addSubview(contentView)
        addSubview(loadingIndicatorView)

        contentView.fillInSuperview()

        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalToConstant: .largeSpacing),
            loadingIndicatorView.heightAnchor.constraint(equalToConstant: .largeSpacing)
        ])

        addTarget(self, action: #selector(handleValueChange), for: .valueChanged)
    }

    // MARK: - Animations

    public override func beginRefreshing() {
        guard !isRefreshing else { return }
        super.beginRefreshing()
        startAnimatingLoadingIndicator()
    }

    public override func endRefreshing() {
        guard isRefreshing else { return }
        super.endRefreshing()
    }

    @objc private func handleValueChange() {
        startAnimatingLoadingIndicator()
    }

    private func startAnimatingLoadingIndicator() {
        isAnimating = true
        loadingIndicatorView.progress = 1
        loadingIndicatorView.startAnimating()
        delegate?.refreshControlDidBeginRefreshing(self)
    }

    private func stopAnimatingLoadingIndicator() {
        loadingIndicatorView.stopAnimating()
        isAnimating = false
        loadingIndicatorView.isHidden = false
    }
}
