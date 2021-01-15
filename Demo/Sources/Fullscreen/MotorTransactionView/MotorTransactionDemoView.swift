//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import FinniversKit

final class MotorTransactionDemoView: UIView {
    private var selectedSegment: Int = 0 {
        didSet {
            segmentedControl.selectedSegmentIndex = selectedSegment
            updateModel()
        }
    }

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(withAutoLayout: true)
        control.insertSegment(withTitle: "Seller", at: 0, animated: false)
        control.insertSegment(withTitle: "Buyer", at: 1, animated: false)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)

        if #available(iOS 13.0, *) {
            control.selectedSegmentTintColor = .bgTertiary
            control.backgroundColor = .bgSecondary
        } else {
            control.tintColor = .white
        }
        return control
    }()

    private var transactionView: MotorTransactionView?
    private var layoutConstraints: [NSLayoutConstraint] = []

    private lazy var dataSource = MotorTransactionDefaultData()
    private lazy var model: MotorTransactionViewModel = dataSource.sellerProcessState()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        if transactionView != nil {
            transactionView?.removeFromSuperview()
            layoutConstraints.removeAll()
        }

        transactionView = MotorTransactionView(withAutoLayout: true, model: model, dataSource: self, delegate: self)

        addSubview(transactionView!)
        addSubview(segmentedControl)

        setupConstraints()
    }

    private func setupConstraints() {
        guard let view = transactionView else { return }

        layoutConstraints.append(contentsOf: [
            segmentedControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
        ])

        switch traitCollection.horizontalSizeClass {
        case .regular:
            layoutConstraints.append(contentsOf: [
                view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingXXL * 3),
                view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
                view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.spacingXXL),
            ])
        default:
            layoutConstraints.append(contentsOf: [
                view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
                view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
                view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        }

        NSLayoutConstraint.activate(layoutConstraints)
    }

    private func changeModel() {
        if selectedSegment == 0 {
            model = dataSource.sellerProcessState()
        } else {
            model = dataSource.buyerProcessState()
        }
        configure()
    }

    private func updateModel() {
        if selectedSegment == 0 {
            model = dataSource.getNextSellerProcessState()
        } else {
            model = dataSource.getNextBuyerProcessState()
        }

        configure()
    }

    @objc func handleSegmentChange() {
        selectedSegment = segmentedControl.selectedSegmentIndex
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard previousTraitCollection != traitCollection else { return }
        setupConstraints()
    }
}

// MARK: MotorTransactionViewDelegate

extension MotorTransactionDemoView: MotorTransactionViewDelegate {
    func motorTransactionViewDidBeginRefreshing(_ refreshControl: RefreshControl) {
        print("Did pull to refresh")
        updateModel()
        refreshControl.endRefreshing()
    }

    //swiftlint:disable:next function_parameter_count
    func motorTransactionViewDidTapButton(
        _ view: MotorTransactionView,
        inStep step: Int,
        inContentView kind: MotorTransactionStepContentView.Kind,
        withButtonTag tag: MotorTransactionButton.Tag,
        withAction action: MotorTransactionButton.Action,
        withUrl urlString: String?,
        withFallbackUrl fallbackUrlString: String?
    ) {
        print("Did tap button with tag: \(tag) in step: \(step) in view: \(kind), with action: \(action.rawValue), with urlString: \(urlString ?? ""), with fallbackUrl:\(fallbackUrlString ?? "")")
    }
}

// MARK: MotorTransactionViewDataSource

extension MotorTransactionDemoView: MotorTransactionViewDataSource {
    func motorTransactionView(_ view: MotorTransactionView, loadImageWithUrl url: URL, completion: @escaping ((UIImage?) -> Void)) {

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func motorTransactionView(_ view: MotorTransactionView, cancelLoadingImageWithUrl url: URL) {}

    func motorTransactionViewNumberOfSteps(_ view: MotorTransactionView) -> Int {
        return model.steps.count
    }

    func motorTransactionViewCurrentStep(_ view: MotorTransactionView) -> Int {
        let hasCompletedAllSteps = model.steps.allSatisfy({ $0.state == .completed })
        let activeStep = model.steps.firstIndex(where: { $0.state == .active }) ?? 0
        let lastStep = model.steps.count
        return hasCompletedAllSteps ? lastStep : activeStep
    }

    func motorTransactionViewModelForIndex(_ view: MotorTransactionView, forStep step: Int) -> MotorTransactionStepViewModel {
        return model.steps[step]
    }
}
