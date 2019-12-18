//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol LoanCalculatorViewModel: LoanHeaderViewModel, LoanValuesViewModel, LoanApplyViewModel {}

public extension LoanCalculatorViewModel {
    var accentColor: UIColor? { nil }
}

public protocol LoanCalculatorDataSource: AnyObject {
    func loanCalculatorView(_ view: LoanCalculatorView, formattedCurrencyValue: Float) -> String?
    func loanCalculatorView(_ view: LoanCalculatorView, formattedYearsValue: Int) -> String?
    func loanCalculatorView(_ view: LoanCalculatorView, loadImageWithUrl: URL, completion: @escaping ((UIImage?) -> Void))
    func loanCalculatorView(_ view: LoanCalculatorView, cancelLoadingImageWithUrl: URL)
}

public protocol LoanCalculatorDelegate: AnyObject {
    func loanValuesView(_ view: LoanCalculatorView, didChangePrice price: Float)
    func loanValuesView(_ view: LoanCalculatorView, didChangeEquity equity: Float)
    func loanValuesView(_ view: LoanCalculatorView, didChangePaymentYears years: Int)
    func loanValuesViewDidSelectApply(_ view: LoanCalculatorView)
}

public class LoanCalculatorView: UIView {
    // MARK: - Public properties
    public weak var dataSource: LoanCalculatorDataSource?
    public weak var delegate: LoanCalculatorDelegate?

    public var isLoading = false {
        didSet {
            guard isLoading != oldValue else { return }
            animateLoading()
        }
    }

    // MARK: - Private properties
    private let imageCache = ImageMemoryCache()

    // MARK: - Private subviews
    private lazy var headerView: LoanHeaderView = {
        let view = LoanHeaderView(withAutoLayout: true)
        view.dataSource = self
        return view
    }()

    private lazy var loanValuesView: LoanValuesView = {
        let view = LoanValuesView(withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var applyView: LoanApplyView = {
        let view = LoanApplyView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Public methods
    public func configure(with model: LoanCalculatorViewModel) {
        headerView.configure(with: model)
        loanValuesView.configure(with: model)
        applyView.configure(with: model)
    }

    // MARK: - Private methods
    private func setup() {
        backgroundColor = .bgTertiary
        layer.cornerRadius = .mediumSpacing
        directionalLayoutMargins = .init(all: .mediumLargeSpacing * 1.5)

        addSubview(headerView)
        addSubview(loanValuesView)
        addSubview(applyView)

        let margins = layoutMarginsGuide
        let headerHeight = headerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70)

        if UIDevice.isIPad() {
            NSLayoutConstraint.activate([
                loanValuesView.topAnchor.constraint(equalTo: margins.topAnchor),
                loanValuesView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                loanValuesView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
                loanValuesView.widthAnchor.constraint(equalTo: headerView.widthAnchor),

                headerView.topAnchor.constraint(equalTo: margins.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: loanValuesView.trailingAnchor, constant: .veryLargeSpacing),
                headerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                headerView.bottomAnchor.constraint(equalTo: applyView.topAnchor, constant: -.largeSpacing),
                headerHeight,

                applyView.leadingAnchor.constraint(equalTo: loanValuesView.trailingAnchor, constant: .veryLargeSpacing),
                applyView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                applyView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: margins.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                headerView.bottomAnchor.constraint(equalTo: loanValuesView.topAnchor, constant: -.largeSpacing),
                headerHeight,

                loanValuesView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                loanValuesView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                loanValuesView.bottomAnchor.constraint(equalTo: applyView.topAnchor, constant: -.largeSpacing),

                applyView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                applyView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                applyView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            ])
        }
    }

    private func animateLoading() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .beginFromCurrentState, animations: {
            self.headerView.alpha = self.isLoading ? 0.4 : 1
            self.applyView.isEnabled = !self.isLoading
        }, completion: nil)
    }
}

// MARK: - RemoteImageViewDataSource

extension LoanCalculatorView: RemoteImageViewDataSource {
    public func remoteImageView(
        _ view: RemoteImageView,
        cachedImageWithPath imagePath: String,
        imageWidth: CGFloat
    ) -> UIImage? {
        return imageCache.image(forKey: imagePath)
    }

    public func remoteImageView(
        _ view: RemoteImageView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        dataSource?.loanCalculatorView(self, loadImageWithUrl: url, completion: { [weak self] image in
            if let image = image {
                self?.imageCache.add(image, forKey: imagePath)
            }
            completion(image)
        })
    }

    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {
        guard let url = URL(string: imagePath) else { return }
        dataSource?.loanCalculatorView(self, cancelLoadingImageWithUrl: url)
    }
}

// MARK: - LoanValuesViewDataSource

extension LoanCalculatorView: LoanValuesViewDataSource {
    func loanValuesView(_ view: LoanValuesView, formattedCurrencyValue value: Float) -> String? {
        return dataSource?.loanCalculatorView(self, formattedCurrencyValue: value)
    }

    func loanValuesView(_ view: LoanValuesView, formattedYearsValue value: Int) -> String? {
        return dataSource?.loanCalculatorView(self, formattedYearsValue: value)
    }
}

// MARK: - LoanValuesViewDelegate

extension LoanCalculatorView: LoanValuesViewDelegate {
    func loanValuesViewDidChangeValue(_ view: LoanValuesView) {
        isLoading = true
    }

    func loanValuesView(_ view: LoanValuesView, didChangePrice price: Float) {
        delegate?.loanValuesView(self, didChangePrice: price)
    }

    func loanValuesView(_ view: LoanValuesView, didChangeEquity equity: Float) {
        delegate?.loanValuesView(self, didChangeEquity: equity)
    }

    func loanValuesView(_ view: LoanValuesView, didChangePaymentYears years: Int) {
        delegate?.loanValuesView(self, didChangePaymentYears: years)
    }
}

// MARK: - LoanApplyViewDelegate

extension LoanCalculatorView: LoanApplyViewDelegate {
    func loanApplyViewDidSelectApply(_ view: LoanApplyView) {
        delegate?.loanValuesViewDidSelectApply(self)
    }
}
