//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - ReceiptViewDelegate

public protocol ReceiptViewDelegate: class {
    func receipt(_ : ReceiptView, didTapNavigateToAd button: Button)
    func receipt(_ : ReceiptView, didTapNavigateToMyAds button: Button)
    func receipt(_ : ReceiptView, didTapCreateNewAd button: Button)
    func receiptInsertViewBelowDetailText(_ : ReceiptView) -> UIView?
}

public class ReceiptView: UIView {
    // MARK: - Internal properties

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(withAutoLayout: true)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private lazy var contentView: UIView = UIView(withAutoLayout: true)
    private lazy var buttonContentView: UIView = UIView(withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    private lazy var hairlineView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .sardine
        return view
    }()

    private lazy var bodyLabel: Label = {
        let view = Label(style: .body)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()

    private lazy var navigateToAdButton: Button = {
       let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(navigateToAdButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var navigateToMyAdsButton: Button = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(navigateToMyAdsButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var createNewAdButton: Button = {
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createNewAdButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Dependency injection

    public var model: ReceiptViewModel? {
        didSet {
            guard let model = model else { return }
            titleLabel.text = model.title
            bodyLabel.text = model.body
            navigateToAdButton.setTitle(model.navigateToAdButtonText, for: .normal)
            navigateToMyAdsButton.setTitle(model.navigateToMyAdsButtonText, for: .normal)
            createNewAdButton.setTitle(model.createNewAdButtonText, for: .normal)
        }
    }

    // MARK: - External properties

    private weak var delegate: ReceiptViewDelegate?

    // MARK: - Setup

    public init(delegate: ReceiptViewDelegate?) {
        super.init(frame: .zero)
        self.delegate = delegate
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(hairlineView)
        contentView.addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: .veryLargeSpacing),

            hairlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            hairlineView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            hairlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),
            hairlineView.heightAnchor.constraint(equalToConstant: (1.0 / UIScreen.main.scale)),

            bodyLabel.topAnchor.constraint(equalTo: hairlineView.topAnchor, constant: .mediumLargeSpacing),
            bodyLabel.leadingAnchor.constraint(equalTo: hairlineView.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: hairlineView.trailingAnchor),
        ])

        if let view = delegate?.receiptInsertViewBelowDetailText(self) {
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)

            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: .largeSpacing),
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),
                view.heightAnchor.constraint(equalToConstant: 160),
            ])
        }

        contentView.addSubview(buttonContentView)
        buttonContentView.addSubview(navigateToAdButton)
        buttonContentView.addSubview(navigateToMyAdsButton)
        buttonContentView.addSubview(createNewAdButton)

        let insertedViewOrBodyLabel = delegate?.receiptInsertViewBelowDetailText(self) ?? bodyLabel

        NSLayoutConstraint.activate([
            buttonContentView.topAnchor.constraint(equalTo: insertedViewOrBodyLabel.bottomAnchor, constant: .largeSpacing),
            buttonContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            buttonContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            buttonContentView.heightAnchor.constraint(equalToConstant: 200),

            navigateToAdButton.topAnchor.constraint(equalTo: buttonContentView.topAnchor, constant: .mediumSpacing),
            navigateToAdButton.leadingAnchor.constraint(equalTo: buttonContentView.leadingAnchor, constant: .mediumSpacing),
            navigateToAdButton.trailingAnchor.constraint(equalTo: buttonContentView.trailingAnchor, constant: -.mediumSpacing),

            navigateToMyAdsButton.topAnchor.constraint(equalTo: navigateToAdButton.bottomAnchor, constant: .mediumLargeSpacing),
            navigateToMyAdsButton.leadingAnchor.constraint(equalTo: navigateToAdButton.leadingAnchor),
            navigateToMyAdsButton.trailingAnchor.constraint(equalTo: navigateToAdButton.trailingAnchor),

            createNewAdButton.topAnchor.constraint(equalTo: navigateToMyAdsButton.bottomAnchor, constant: .mediumLargeSpacing),
            createNewAdButton.leadingAnchor.constraint(equalTo: navigateToMyAdsButton.leadingAnchor),
            createNewAdButton.trailingAnchor.constraint(equalTo: navigateToMyAdsButton.trailingAnchor),
        ])
    }

    @objc private func navigateToAdButtonTapped(_ sender: Button) {
        delegate?.receipt(self, didTapNavigateToAd: sender)
    }

    @objc private func navigateToMyAdsButtonTapped(_ sender: Button) {
        delegate?.receipt(self, didTapNavigateToMyAds: sender)
    }

    @objc private func createNewAdButtonTapped(_ sender: Button) {
        delegate?.receipt(self, didTapCreateNewAd: sender)
    }
}
