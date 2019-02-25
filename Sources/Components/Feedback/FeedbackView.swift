//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - FeedbackViewDelegate

public protocol FeedbackViewDelegate: class {
    func feedbackView(_ feedbackView: FeedbackView, didSelectButtonOfType buttonType: FeedbackView.ButtonType, forState state: FeedbackView.State)
}

// MARK: - FeedbackView

public class FeedbackView: UIView {
    public enum ButtonType {
        case positive
        case negative
    }

    public enum State {
        case initial
        case accept
        case decline
        case finished
    }

    // MARK: - Public properties

    public weak var delegate: FeedbackViewDelegate?

    // MARK: - Private properties

    private var state: State = .initial
    private var presentation: FeedbackViewPresentation? {
        didSet {
            guard let presentation = presentation else { return }
            switch presentation {
            case .grid:
                buttonStackView.axis = .vertical
            case .list:
                buttonStackView.axis = .horizontal
            }
            titleView.configure(forPresentation: presentation)
        }
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .ratingCat)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleView = TitleView(withAutoLayout: true)

    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .mediumSpacing
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(negativeButton)
        stackView.addArrangedSubview(positiveButton)
        return stackView
    }()

    private lazy var positiveButton: UIButton = {
        let button = Button(style: .callToAction, size: .small)
        button.titleLabel?.font = .title5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(positiveButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var negativeButton: UIButton = {
        let button = Button(style: .default, size: .small)
        button.titleLabel?.font = .title5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(negativeButtonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = .primaryBlue
        return button
    }()

    private lazy var gridPresentationConstraints: [NSLayoutConstraint] = [
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
        imageView.heightAnchor.constraint(equalToConstant: 130),
        titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .mediumSpacing),
        titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
        buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
        buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
    ]

    private lazy var listPresentationConstraints: [NSLayoutConstraint] = [
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
        imageView.widthAnchor.constraint(equalToConstant: 130),
        titleView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
        titleView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .mediumSpacing),
        buttonStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .mediumSpacing),
        buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing)
    ]

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .ice

        layer.borderWidth = 1
        layer.borderColor = .sardine
        layer.cornerRadius = 8
        layer.masksToBounds = true

        addSubview(imageView)
        addSubview(titleView)
        addSubview(buttonStackView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),

            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            titleView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -.mediumSpacing),

            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing)
        ])
    }

    // MARK: - Public methods

    public func setState(_ state: State, withViewModel viewModel: FeedbackViewModel) {
        self.state = state
        configure(withViewModel: viewModel)
    }

    // MARK: - Private methods

    private func configure(withViewModel viewModel: FeedbackViewModel) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.titleView.alpha = 0
            self.titleView.setTitle(viewModel.title)
            self.titleView.alpha = 1
        }

        // PositiveButton.
        positiveButton.isHidden = viewModel.positiveButtonTitle == nil
        positiveButton.setTitle(viewModel.positiveButtonTitle, for: .normal)

        // NegativeButton.
        negativeButton.isHidden = viewModel.negativeButtonTitle == nil
        negativeButton.setTitle(viewModel.negativeButtonTitle, for: .normal)
    }

    @objc private func positiveButtonTapped() {
        delegate?.feedbackView(self, didSelectButtonOfType: .positive, forState: state)
    }

    @objc private func negativeButtonTapped() {
        delegate?.feedbackView(self, didSelectButtonOfType: .negative, forState: state)
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()

        let newPresentation: FeedbackViewPresentation = bounds.size.height >= bounds.size.width ? .grid : .list
        guard newPresentation != presentation else { return }
        if newPresentation == .grid {
            NSLayoutConstraint.deactivate(listPresentationConstraints)
            NSLayoutConstraint.activate(gridPresentationConstraints)
        } else {
            NSLayoutConstraint.deactivate(gridPresentationConstraints)
            NSLayoutConstraint.activate(listPresentationConstraints)
        }

        presentation = newPresentation
        setNeedsLayout()
    }
}

// MARK: - FeedbackViewPresentation

private enum FeedbackViewPresentation {
    case list
    case grid
}

// MARK: - TitleView

private class TitleView: UIView {

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .title4
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    private lazy var titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabelLeadingConstraint,
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing)
        ])
    }

    // MARK: - Public methods

    func setTitle(_ text: String?) {
        titleLabel.text = text
    }

    func configure(forPresentation presentation: FeedbackViewPresentation) {
        switch presentation {
        case .list:
            titleLabel.textAlignment = .left
            titleLabel.font = .captionHeavy
            titleLabelLeadingConstraint.constant = 0
        case .grid:
            titleLabel.textAlignment = .center
            titleLabel.font = .title4
            titleLabelLeadingConstraint.constant = .mediumSpacing
        }
    }
}
