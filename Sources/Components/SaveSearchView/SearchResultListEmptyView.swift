//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

// MARK: - SearchResultListEmptyViewDelegate

public protocol SearchResultListEmptyViewDelegate: AnyObject {
    func searchResultListEmptyViewDidSelectActionButton(_ searchResultListEmptyView: SearchResultListEmptyView, forState state: SearchResultListEmptyView.SearchResultListEmptyViewState)
}

@objc public class SearchResultListEmptyView: UIView {

    // MARK: - Public properties

    @objc public enum SearchResultListEmptyViewState: Int {
        case initial = 0
        case searchSaved
        case searchSavedNoPush
    }

    public weak var delegate: SearchResultListEmptyViewDelegate?

    // MARK: - Private properties

    private var state: SearchResultListEmptyViewState = .initial

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

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.font = .bodyStrong
        label.numberOfLines = 1
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.font = .caption
        label.numberOfLines = 2
        return label
    }()

    private lazy var button: UIButton = {
        let button = Button(style: .utility, size: .small)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
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

            stackView.topAnchor.constraint(equalTo: topAnchor, constant: .veryLargeSpacing * 3),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            button.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .mediumLargeSpacing),
            button.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    // MARK: - Public methods

    public func configure(withViewModel viewModel: SearchResultListEmptyViewModel, forState state: SearchResultListEmptyView.SearchResultListEmptyViewState) {
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
        delegate?.searchResultListEmptyViewDidSelectActionButton(self, forState: state)
    }
}
