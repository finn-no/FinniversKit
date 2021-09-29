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
    private var presentation: FeedbackViewPresentation?
    private var allowAutomaticPresentationSwitch: Bool = true

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .ratingCat)
        imageView.contentMode = .scaleAspectFit
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
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
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
        imageView.heightAnchor.constraint(equalToConstant: 130),
        titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: TitleView.verticalSpacing),
        titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
        buttonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
        buttonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM)
    ]

    private lazy var listPresentationConstraints: [NSLayoutConstraint] = [
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS),
        imageView.widthAnchor.constraint(equalToConstant: 130),
        titleView.topAnchor.constraint(equalTo: topAnchor, constant: TitleView.verticalSpacing),
        titleView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .spacingS),
        buttonView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .spacingS),
        buttonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS)
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
        layer.cornerRadius = 8
        layer.masksToBounds = true

        addSubview(imageView)
        addSubview(titleView)
        addSubview(buttonView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),

            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            titleView.bottomAnchor.constraint(equalTo: buttonView.topAnchor, constant: -TitleView.verticalSpacing),

            buttonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS)
        ])
    }

    // MARK: - Public methods

    public func configureWithFixedPresentation(isGrid: Bool) {
        allowAutomaticPresentationSwitch = false
        let presentation: FeedbackViewPresentation = isGrid ? .grid : .list
        configure(forPresentation: presentation)
    }

    public func setState(_ state: State, withViewModel viewModel: FeedbackViewModel) {
        self.state = state
        configure(withViewModel: viewModel)
    }

    public func setImage(_ image: UIImage) {
        imageView.image = image
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

    private func configure(forPresentation presentation: FeedbackViewPresentation) {
        switch presentation {
        case .list:
            NSLayoutConstraint.deactivate(gridPresentationConstraints)
            NSLayoutConstraint.activate(listPresentationConstraints)
        case .grid:
            NSLayoutConstraint.deactivate(listPresentationConstraints)
            NSLayoutConstraint.activate(gridPresentationConstraints)
        }
        titleView.configure(forPresentation: presentation)
        buttonView.configure(forPresentation: presentation)
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
        hasBeenPresented = true

        layer.borderColor = .decorationSubtle

        guard allowAutomaticPresentationSwitch else { return }

        let newPresentation: FeedbackViewPresentation = bounds.size.height >= bounds.size.width ? .grid : .list

        guard newPresentation != presentation else { return }
        presentation = newPresentation

        configure(forPresentation: newPresentation)
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
    static let verticalSpacing: CGFloat = .spacingS

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

    private lazy var titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS)

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
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),

            heightAnchor.constraint(equalTo: titleLabel.heightAnchor, constant: 2 * TitleView.verticalSpacing, priority: .defaultLow)
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
            titleLabelLeadingConstraint.constant = .spacingS
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

    lazy var negativeButton: Button = {
        let button = Button(style: .negativeButton(), size: .small)
        button.titleLabel?.font = .detailStrong
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Private properties

    private var currentPresentation: FeedbackViewPresentation?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.spacing = .spacingS
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
        stackView.fillInSuperview()
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

private extension Button.Style {
    static func negativeButton() -> Button.Style {
        Button.Style.default.overrideStyle(
            borderWidth: 1.0,
            borderColor: .btnPrimary
        )
    }
}
