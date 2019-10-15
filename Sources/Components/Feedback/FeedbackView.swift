//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - FeedbackViewDelegate

public protocol FeedbackViewDelegate: AnyObject {
    func feedbackView(_ feedbackView: FeedbackView, didSelectButtonOfType buttonType: FeedbackView.ButtonType, forState state: FeedbackView.State)
}

// MARK: - FeedbackView

public class FeedbackView: UIView {
    public enum ButtonType {
        case positive
        case negative
    }

    @objc public enum State: Int {
        case initial = 0
        case accept
        case decline
        case finished
    }

    // MARK: - Public properties

    public weak var delegate: FeedbackViewDelegate?

    // MARK: - Private properties

    private var hasBeenPresented = false
    private var state: State = .initial
    private var presentation: FeedbackViewPresentation? {
        didSet {
            guard let presentation = presentation else { return }
            titleView.configure(forPresentation: presentation)
            buttonView.configure(forPresentation: presentation)
        }
    }

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .ratingCat)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleView = TitleView(withAutoLayout: true)

    private lazy var buttonView: ButtonView = {
        let buttonView = ButtonView(withAutoLayout: true)
        buttonView.positiveButton.addTarget(self, action: #selector(positiveButtonTapped), for: .touchUpInside)
        buttonView.negativeButton.addTarget(self, action: #selector(negativeButtonTapped), for: .touchUpInside)
        return buttonView
    }()

    private lazy var gridPresentationConstraints: [NSLayoutConstraint] = [
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
        imageView.heightAnchor.constraint(equalToConstant: 130),
        titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .mediumSpacing),
        titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
        buttonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
        buttonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
    ]

    private lazy var listPresentationConstraints: [NSLayoutConstraint] = [
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
        imageView.widthAnchor.constraint(equalToConstant: 130),
        titleView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
        titleView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .mediumSpacing),
        buttonView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .mediumSpacing),
        buttonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing)
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
        backgroundColor = .bgSecondary

        layer.borderWidth = 1
        layer.borderColor = .sardine
        layer.cornerRadius = 8
        layer.masksToBounds = true

        addSubview(imageView)
        addSubview(titleView)
        addSubview(buttonView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),

            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            titleView.bottomAnchor.constraint(equalTo: buttonView.topAnchor, constant: -.mediumSpacing),

            buttonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing)
        ])
    }

    // MARK: - Public methods

    public func setState(_ state: State, withViewModel viewModel: FeedbackViewModel) {
        self.state = state
        configure(withViewModel: viewModel)
    }

    // MARK: - Private methods

    private func configure(withViewModel viewModel: FeedbackViewModel) {
        if !hasBeenPresented {
            titleView.setTitle(viewModel.title)
        } else {
            guard let snapshotTitleView = titleView.snapshotView(afterScreenUpdates: false) else { return }
            snapshotTitleView.frame = titleView.frame
            addSubview(snapshotTitleView)

            titleView.transform = CGAffineTransform(translationX: 0, y: 30)
            titleView.alpha = 0
            titleView.setTitle(viewModel.title)
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                self?.titleView.transform = .identity
                self?.titleView.alpha = 1
                snapshotTitleView.alpha = 0
                snapshotTitleView.transform = CGAffineTransform(translationX: 0, y: -30)
            }, completion: { _ in
                snapshotTitleView.removeFromSuperview()
            })
        }

        buttonView.setButtonTitles(positive: viewModel.positiveButtonTitle, negative: viewModel.negativeButtonTitle)
    }

    @objc private func positiveButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        delegate?.feedbackView(self, didSelectButtonOfType: .positive, forState: state)
    }

    @objc private func negativeButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
        hasBeenPresented = true
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
        label.font = .bodyStrong
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
            titleLabel.font = .captionStrong
            titleLabelLeadingConstraint.constant = 0
        case .grid:
            titleLabel.textAlignment = .center
            titleLabel.font = .bodyStrong
            titleLabelLeadingConstraint.constant = .mediumSpacing
        }
    }
}

// MARK: - ButtonView

private class ButtonView: UIView {

    // MARK: - Public properties

    lazy var positiveButton: UIButton = {
        let button = Button(style: .callToAction, size: .small)
        button.titleLabel?.font = .detailStrong
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var negativeButton: UIButton = {
        let button = Button(style: .default, size: .small)
        button.titleLabel?.font = .detailStrong
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        button.layer.borderColor = .btnPrimary
        return button
    }()

    // MARK: - Private properties

    private var currentPresentation: FeedbackViewPresentation?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.spacing = .mediumSpacing
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(positiveButton)
        stackView.addArrangedSubview(negativeButton)
        return stackView
    }()

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
        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public methods

    func setButtonTitles(positive: String?, negative: String?) {
        positiveButton.isHidden = positive == nil
        positiveButton.setTitle(positive, for: .normal)

        negativeButton.isHidden = negative == nil
        negativeButton.setTitle(negative, for: .normal)
    }

    func configure(forPresentation presentation: FeedbackViewPresentation) {
        guard presentation != currentPresentation else { return }

        if !stackView.arrangedSubviews.isEmpty {
            positiveButton.removeFromSuperview()
            negativeButton.removeFromSuperview()
        }

        switch presentation {
        case .list:
            stackView.axis = .horizontal
            stackView.addArrangedSubview(negativeButton)
            stackView.addArrangedSubview(positiveButton)
        case .grid:
            stackView.axis = .vertical
            stackView.addArrangedSubview(positiveButton)
            stackView.addArrangedSubview(negativeButton)
        }

        currentPresentation = presentation
    }
}
