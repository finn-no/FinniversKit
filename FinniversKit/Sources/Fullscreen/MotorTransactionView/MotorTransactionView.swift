//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol MotorTransactionViewDelegate: AnyObject {
    func motorTransactionViewDidBeginRefreshing(_ refreshControl: RefreshControl)

    //swiftlint:disable:next function_parameter_count

    func motorTransactionViewDidTapButton(
        _ view: MotorTransactionView,
        inStep step: Int,
        inContentView kind: MotorTransactionStepContentView.Kind,
        withButtonTag tag: MotorTransactionButton.Tag,
        withAction action: MotorTransactionButton.Action,
        withUrl urlString: String?,
        withFallbackUrl fallbackUrlString: String?
    )
}

public protocol MotorTransactionViewDataSource: AnyObject {
    func motorTransactionViewModelForIndex(_ view: MotorTransactionView, forStep step: Int) -> MotorTransactionStepViewModel
    func motorTransactionViewNumberOfSteps(_ view: MotorTransactionView) -> Int
    func motorTransactionViewCurrentStep(_ view: MotorTransactionView) -> Int
    func motorTransactionView(_ view: MotorTransactionView, loadImageWithUrl url: URL, completion: @escaping ((UIImage?) -> Void))
    func motorTransactionView(_ view: MotorTransactionView, cancelLoadingImageWithUrl url: URL)
}

public class MotorTransactionView: UIView {

    // MARK: - Properties

    private var model: MotorTransactionViewModel?
    private weak var dataSource: MotorTransactionViewDataSource?
    private weak var delegate: MotorTransactionViewDelegate?

    private var numberOfSteps: Int = 0
    private var currentStep: Int = 0

    private let imageCache = ImageMemoryCache()

    // MARK: - UIView properties

    private var headerView: MotorTransactionHeaderView?
    private var alertView: MotorTransactionAlertView?

    private var stepDots = [MotorTransactionStepDot]()
    private var connectors = [MotorTransactionStepDotConnector]()

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

    private(set) public lazy var contentView = UIView(withAutoLayout: true)

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = .spacingM
        return stackView
    }()

    // MARK: - Init

    public init(withAutoLayout autoLayout: Bool = true, model: MotorTransactionViewModel,
                dataSource: MotorTransactionViewDataSource, delegate: MotorTransactionViewDelegate) {

        self.model = model
        self.dataSource = dataSource
        self.delegate = delegate

        super.init(frame: .zero)

        self.numberOfSteps = dataSource.motorTransactionViewNumberOfSteps(self)
        self.currentStep = dataSource.motorTransactionViewCurrentStep(self)

        translatesAutoresizingMaskIntoConstraints = !autoLayout

        setup()
        progressTo(currentStep)
    }

    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private

private extension MotorTransactionView {
    func setup() {
        backgroundColor = .bgPrimary

        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.addSubview(contentView)

        contentView.fillInSuperview()
        contentView.addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        setupHeaderView()
        setupAlertView()

        for index in 0..<numberOfSteps {
            guard let model = dataSource?.motorTransactionViewModelForIndex(self, forStep: index) else { return }
            setupTransactionStepView(index, model)
            setupTransactionStepDot(index)
        }

        setupVerticalStackViewContraints()
        contentView.bottomAnchor.constraint(greaterThanOrEqualTo: verticalStackView.bottomAnchor).isActive = true
    }

    func setupHeaderView() {
        if let headerViewModel = model?.header {
            headerView = MotorTransactionHeaderView(withAutoLayout: true, model: headerViewModel)
            headerView?.dataSource = self
            headerView?.loadImage()

            guard let view = headerView else { return }

            contentView.addSubview(view)

            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
                view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            ])

            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: .spacingM)
        }
    }

    func setupAlertView() {
        if let alertViewModel = model?.alert {
            alertView = MotorTransactionAlertView(withAutoLayout: true, model: alertViewModel)
            guard let view = alertView else { return }

            contentView.addSubview(view)

            if let header = headerView {
                verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(
                    equalTo: view.bottomAnchor,
                    constant: .spacingM)

                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
                    view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
                    view.topAnchor.constraint(equalTo: header.bottomAnchor, constant: .spacingM),
                ])
            } else {
                NSLayoutConstraint.activate([
                    view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
                    view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
                    view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),
                ])
            }

            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: .spacingM)
        }
    }

    func setupTransactionStepView(_ step: Int, _ model: MotorTransactionStepViewModel) {
        let transactionStepView = MotorTransactionStepView(
            step: step,
            currentStep: currentStep,
            model: model,
            withCustomStyle: model.style,
            withAutoLayout: true
        )
        transactionStepView.delegate = self
        verticalStackView.addArrangedSubview(transactionStepView)
    }

    func setupTransactionStepDot(_ step: Int) {
        let stepDot = MotorTransactionStepDot(step: step)
        stepDots.append(stepDot)

        guard let currentStepView = verticalStackView.arrangedSubviews[safe: step] as? MotorTransactionStepView else { return }

        contentView.addSubview(stepDot)
        NSLayoutConstraint.activate([
            stepDot.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingXL),
            stepDot.topAnchor.constraint(equalTo: currentStepView.topAnchor),
        ])

        guard let previousStepDot = stepDots[safe: step - 1] else { return }
        let connector = MotorTransactionStepDotConnector(withAutoLayout: true)
        connectors.append(connector)

        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.addArrangedSubview(connector)

        contentView.addSubview(stackView)
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
            let lastStepView = verticalStackView.arrangedSubviews.last
        else { return }

        verticalStackViewLeadingAnchor = verticalStackView.leadingAnchor.constraint(
            equalTo: firstStepDot.trailingAnchor, constant: .spacingS)

        verticalStackViewBottomAnchor = verticalStackView.bottomAnchor.constraint(equalTo: lastStepView.bottomAnchor)

        guard let stackViewLeadingAnchor = verticalStackViewLeadingAnchor,
              let stackViewTopAnchor = verticalStackViewTopAnchor,
              let stackViewBottomAnchor = verticalStackViewBottomAnchor
        else { return }

        NSLayoutConstraint.activate([
            stackViewLeadingAnchor,
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingXL),
            stackViewTopAnchor,
            stackViewBottomAnchor,
        ])
    }

    func progressTo(_ step: Int) {
        for index in 0..<currentStep {
            stepDots[safe: index]?.setState(.completed)
            connectors[safe: index]?.highlighted = true
        }

        if step == numberOfSteps - 1 {
            stepDots[safe: currentStep]?.setState(.completed)
        } else {
            stepDots[safe: currentStep]?.setState(.inProgress)
        }
    }
}

// MARK: - TransactionStepViewDelegate

extension MotorTransactionView: MotorTransactionStepViewDelegate {

    //swiftlint:disable:next function_parameter_count

    public func motorTransactionStepViewDidTapButton(
        _ view: MotorTransactionStepView,
        inStep step: Int,
        inContentView kind: MotorTransactionStepContentView.Kind,
        withButtonTag tag: MotorTransactionButton.Tag,
        withAction action: MotorTransactionButton.Action,
        withUrl urlString: String?,
        withFallbackUrl fallbackUrlString: String?
    ) {
        delegate?.motorTransactionViewDidTapButton(
            self,
            inStep: step,
            inContentView: kind,
            withButtonTag: tag,
            withAction: action,
            withUrl: urlString,
            withFallbackUrl: fallbackUrlString)
    }
}

// MARK: - RefreshControlDelegate

extension MotorTransactionView: RefreshControlDelegate {
    public func refreshControlDidBeginRefreshing(_ refreshControl: RefreshControl) {
        delegate?.motorTransactionViewDidBeginRefreshing(refreshControl)
    }
}

extension MotorTransactionView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return imageCache.image(forKey: imagePath)
    }

    public func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        dataSource?.motorTransactionView(self, loadImageWithUrl: url, completion: { [weak self] image in
            if let image = image {
                self?.imageCache.add(image, forKey: imagePath)
            }
            completion(image)
        })
    }

    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {
        guard let url = URL(string: imagePath) else { return }
        dataSource?.motorTransactionView(self, cancelLoadingImageWithUrl: url)
    }
}
