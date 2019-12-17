//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

// MARK: - SearchListEmptyViewDelegate

public protocol SearchListEmptyViewDelegate: AnyObject {
    func searchListEmptyViewDidSelectActionButton(_ searchListEmptyView: SearchListEmptyView, forState state: SearchListEmptyView.SearchListEmptyViewState)
}

@objc public class SearchListEmptyView: UIView {

    // MARK: - Public properties

    @objc public enum SearchListEmptyViewState: Int {
        case initial = 0
        case searchSaved
        case searchSavedNoPush
    }

    public weak var delegate: SearchListEmptyViewDelegate?

    // MARK: - Private properties

    private var state: SearchListEmptyViewState = .initial

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .sardine
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: .notifications).withRenderingMode(.alwaysTemplate)
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyLabel: Label = {
        let label = Label(style: .caption)
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var button: Button = {
        let button = Button(style: .utility, size: .small)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)

        stackView.setCustomSpacing(.mediumLargeSpacing, after: iconImageView)
        stackView.setCustomSpacing(.verySmallSpacing, after: titleLabel)

        addSubview(stackView)
        addSubview(button)

        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            stackView.topAnchor.constraint(equalTo: centerYAnchor, constant: .veryLargeSpacing * -2),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            button.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .mediumLargeSpacing),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 31)
        ])
    }

    // MARK: - Public methods

    public func configure(withViewModel viewModel: SearchListEmptyViewModel, forState state: SearchListEmptyView.SearchListEmptyViewState) {
        self.state = state
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.body
        if let buttonTitle = viewModel.buttonTitle {
            button.setTitle(buttonTitle, for: .normal)
            button.isHidden = false
        } else {
            button.isHidden = true
        }
    }

    // MARK: - Private methods

    @objc private func buttonTapped() {
        delegate?.searchListEmptyViewDidSelectActionButton(self, forState: state)
    }
}
