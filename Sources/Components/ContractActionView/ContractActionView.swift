//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ContractActionViewDelegate: AnyObject {
    func contractActionView(_ view: ContractActionView, didSelectActionButtonWithUrl url: URL)
}

public class ContractActionView: UIView {

    // MARK: - Public properties

    public weak var delegate: ContractActionViewDelegate?
    private(set) var identifier: String?
    private(set) var buttonUrl: URL?

    // MARK: - Private properties

    private let buttonStyle = Button.Style.default.overrideStyle(borderColor: .btnDisabled)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bulletListLabel, actionButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = .mediumPlusSpacing
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var bulletListLabel: Label = {
        let label = Label(withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var actionButton: Button = {
        let button = Button(style: buttonStyle, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgTertiary
        layer.cornerRadius = .mediumSpacing
        layoutMargins = UIEdgeInsets(
            top: .mediumLargeSpacing,
            leading: .mediumLargeSpacing,
            bottom: .mediumPlusSpacing,
            trailing: .mediumLargeSpacing
        )

        addSubview(stackView)
        stackView.fillInSuperviewLayoutMargins()
    }

    // MARK: - Public methods

    public func configure(with viewModel: ContractActionViewModel) {
        self.identifier = viewModel.identifier
        self.buttonUrl = viewModel.buttonUrl

        bulletListLabel.attributedText = viewModel.strings.bulletPoints(withFont: .body)
        actionButton.setTitle(viewModel.buttonTitle, for: .normal)
    }

    // MARK: - Private methods

    @objc private func handleActionButtonTap() {
        guard let buttonUrl = buttonUrl else { return }
        delegate?.contractActionView(self, didSelectActionButtonWithUrl: buttonUrl)
    }
}
