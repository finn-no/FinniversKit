//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol RefreshControlDelegate: AnyObject {
    func refreshControlDidBeginRefreshing(_ refreshControl: RefreshControl)
}

/// Branded replacement for UIRefreshControl.
public class RefreshControl: UIRefreshControl {
    public weak var delegate: RefreshControlDelegate?

    private let defaultPullDistance: CGFloat = 100
    private var isAnimating = false
    private lazy var loadingIndicatorView = LoadingIndicatorView(withAutoLayout: true)

    private var topOffset: CGFloat {
        return max(0.0, -frame.origin.y)
    }

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

        setLoadingAlpha()

        // Stop animating when the refresh control scrolls up back to its initial position
        if isAnimating && frame.origin.y == 0 {
            stopAnimatingLoadingIndicator()
        }

        if !isAnimating {
            handleLoadingProgress()
        }
    }

    // MARK: - Setup

    private func setup() {
        tintColor = .white
        addSubview(loadingIndicatorView)

        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalToConstant: .largeSpacing),
            loadingIndicatorView.heightAnchor.constraint(equalToConstant: .largeSpacing)
        ])

        addTarget(self, action: #selector(handleValueChange), for: .valueChanged)
    }

    /// Set alpha value of the loading indicator to avoid overlapping with cells
    private func setLoadingAlpha() {
        let alpha = min(max(topOffset, 0.0), frame.size.height) / frame.size.height
        loadingIndicatorView.alpha = alpha
    }

    /// Set progress based on the current scroll position and begin refreshing if needed.
    private func handleLoadingProgress() {
        let pullDistance = superview.flatMap({ $0.bounds.height / 5 }) ?? defaultPullDistance
        let progress = min(max(topOffset, 0.0), pullDistance) / pullDistance
        loadingIndicatorView.progress = progress

        if topOffset >= pullDistance {
            beginRefreshing()
        }
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
