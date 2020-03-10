//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionViewDelegate: AnyObject {
    func transactionViewDidBeginRefreshing(_ refreshControl: RefreshControl)
    func transactionViewDidSelectPrimaryButton(_ view: TransactionView, inTransactionStep step: Int,
                                               withAction action: TransactionStepView.PrimaryButton.Action, withUrl urlString: String?,
                                               withFallbackUrl fallbackUrlString: String?)
}

public protocol TransactionViewDataSource: AnyObject {
    func transactionViewModelForIndex(_ view: TransactionView, forStep step: Int) -> TransactionStepViewModel
    func transactionViewNumberOfSteps(_ view: TransactionView) -> Int
    func transactionViewCurrentStep(_ view: TransactionView) -> Int
    func transactionView(_ view: TransactionView, loadImageWithUrl url: URL, completion: @escaping ((UIImage?) -> Void))
    func transactionView(_ view: TransactionView, cancelLoadingImageWithUrl url: URL)
}

public class TransactionView: UIView {

    // MARK: - Properties

    private var model: TransactionViewModel?
    private weak var dataSource: TransactionViewDataSource?
    private weak var delegate: TransactionViewDelegate?

    private var numberOfSteps: Int = 0
    private var currentStep: Int = 0

    private let imageCache = ImageMemoryCache()

    // MARK: - UIView properties

    private var headerView: TransactionHeaderView?
    private var warningView: TransactionWarningView?

    private var stepDots = [TransactionStepDot]()
    private var connectors = [TransactionStepDotConnector]()

    private var verticalStackViewLeadingAnchor: NSLayoutConstraint?
    private var verticalStackViewTopAnchor: NSLayoutConstraint?
    private var verticalStackViewBottomAnchor: NSLayoutConstraint?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        let refreshControl = RefreshControl(frame: .zero)
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.refreshControl = refreshControl
        refreshControl.delegate = self
        return scrollView
    }()

    private lazy var scrollableContentView = UIView(withAutoLayout: true)

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = .spacingM
        return stackView
    }()

    // MARK: - Init

    public init(withAutoLayout autoLayout: Bool = true, model: TransactionViewModel,
                dataSource: TransactionViewDataSource, delegate: TransactionViewDelegate) {

        self.model = model
        self.dataSource = dataSource
        self.delegate = delegate

        super.init(frame: .zero)

        self.numberOfSteps = dataSource.transactionViewNumberOfSteps(self)
        self.currentStep = dataSource.transactionViewCurrentStep(self)

        translatesAutoresizingMaskIntoConstraints = !autoLayout

        setup()
        progressTo(currentStep)
    }

    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private

private extension TransactionView {
    func setup() {
        backgroundColor = .bgPrimary

        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.addSubview(scrollableContentView)

        scrollableContentView.fillInSuperview()
        scrollableContentView.addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            scrollableContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            scrollableContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        setupHeaderView()

        for index in 0..<numberOfSteps {
            guard let model = dataSource?.transactionViewModelForIndex(self, forStep: index) else { return }
            setupTransactionStepView(index, model)
            setupTransactionStepDot(index)
        }

        setupVerticalStackViewContraints()
    }

    func setupHeaderView() {
        if let headerViewModel = model?.header {
            headerView = TransactionHeaderView(withAutoLayout: true, model: headerViewModel)
            headerView?.dataSource = self
            headerView?.loadImage()

            guard let view = headerView else { return }

            scrollableContentView.addSubview(view)

            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: scrollableContentView.leadingAnchor, constant: .spacingL),
                view.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor),
                view.topAnchor.constraint(equalTo: scrollableContentView.topAnchor, constant: .spacingS),
            ])

            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: .spacingM)
        }

        setupWarningView()
    }

    func setupWarningView() {
        if let warningViewModel = model?.warning {
            warningView = TransactionWarningView(withAutoLayout: true, model: warningViewModel)
            warningView?.dataSource = self
            warningView?.loadImage()

            guard let view = warningView else { return }

            scrollableContentView.addSubview(view)

            if let header = headerView {
                verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(
                    equalTo: view.bottomAnchor,
                    constant: .spacingM)

                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: scrollableContentView.leadingAnchor, constant: .spacingM),
                    view.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor, constant: -.spacingM),
                    view.topAnchor.constraint(equalTo: header.bottomAnchor, constant: .spacingM),
                ])
            } else {
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: scrollableContentView.leadingAnchor, constant: .spacingM),
                    view.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor, constant: -.spacingM),
                    view.topAnchor.constraint(equalTo: scrollableContentView.topAnchor, constant: .spacingM),
                ])
            }

            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: .spacingM)
        }
    }

    func setupTransactionStepView(_ step: Int, _ model: TransactionStepViewModel) {
        let isLastStep = (step == numberOfSteps - 1)
        let transactionStepView = TransactionStepView(step: step, model: model, withAutoLayout: true)
        transactionStepView.delegate = self
        verticalStackView.addArrangedSubview(transactionStepView)

        if isLastStep && model.state == .completed {
            transactionStepView.hasCompletedLastStep(true)
        }
    }

    func setupTransactionStepDot(_ step: Int) {
        let stepDot = TransactionStepDot(step: step)
        stepDots.append(stepDot)

        guard let currentStepView = verticalStackView.arrangedSubviews[safe: step] as? TransactionStepView else { return }

        scrollableContentView.addSubview(stepDot)
        NSLayoutConstraint.activate([
            stepDot.leadingAnchor.constraint(equalTo: scrollableContentView.leadingAnchor, constant: .spacingXL),
            stepDot.topAnchor.constraint(equalTo: currentStepView.topAnchor),
        ])

        guard let previousStepDot = stepDots[safe: step - 1] else { return }
        let connector = TransactionStepDotConnector(withAutoLayout: true)
        connectors.append(connector)

        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.addArrangedSubview(connector)

        scrollableContentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: stepDot.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: previousStepDot.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: currentStepView.topAnchor)
        ])

        connector.connect(from: stepDot, to: previousStepDot)
    }

    func setupVerticalStackViewContraints() {
        guard
            let firstStepDot = stepDots.first,
            let lastTransactionStepView = verticalStackView.arrangedSubviews.last
        else { return }

        verticalStackViewLeadingAnchor = verticalStackView.leadingAnchor.constraint(
            equalTo: firstStepDot.trailingAnchor, constant: .spacingS)

        verticalStackViewBottomAnchor = verticalStackView.bottomAnchor.constraint(equalTo: lastTransactionStepView.bottomAnchor)

        guard let leadingAnchor = verticalStackViewLeadingAnchor,
              let topAnchor = verticalStackViewTopAnchor,
              let bottomAnchor = verticalStackViewBottomAnchor
        else { return }

        NSLayoutConstraint.activate([
            leadingAnchor,
            verticalStackView.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor, constant: -.spacingXL),
            topAnchor,
            bottomAnchor,
        ])

        if !UIDevice.isIPad() {
            scrollableContentView.bottomAnchor.constraint(
                equalTo: verticalStackView.bottomAnchor, constant: .spacingXL).isActive = true
        }
    }

    func progressTo(_ step: Int) {
        for index in 0..<currentStep {
            stepDots[safe: index]?.setState(.completed)
            connectors[safe: index]?.highlighted = true
        }

        stepDots[safe: currentStep]?.setState(.inProgress)
        stepDots[safe: currentStep]?.setState(.inProgress)
    }
}

// MARK: - TransactionStepViewDelegate

extension TransactionView: TransactionStepViewDelegate {
    public func transactionStepViewDidTapPrimaryButton(_ view: TransactionStepView, inTransactionStep step: Int,
                                                       withAction action: TransactionStepView.PrimaryButton.Action, withUrl url: String?,
                                                       withFallbackUrl fallbackUrl: String?) {

        delegate?.transactionViewDidSelectPrimaryButton(self, inTransactionStep: step,
                                                        withAction: action, withUrl: url,
                                                        withFallbackUrl: fallbackUrl)
    }
}

// MARK: - RefreshControlDelegate

extension TransactionView: RefreshControlDelegate {
    public func refreshControlDidBeginRefreshing(_ refreshControl: RefreshControl) {
        delegate?.transactionViewDidBeginRefreshing(refreshControl)
    }
}

extension TransactionView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return imageCache.image(forKey: imagePath)
    }

    public func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        dataSource?.transactionView(self, loadImageWithUrl: url, completion: { [weak self] image in
            if let image = image {
                self?.imageCache.add(image, forKey: imagePath)
            }
            completion(image)
        })
    }

    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {
        guard let url = URL(string: imagePath) else { return }
        dataSource?.transactionView(self, cancelLoadingImageWithUrl: url)
    }
}
