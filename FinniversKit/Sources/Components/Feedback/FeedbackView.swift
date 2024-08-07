//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

// MARK: - FeedbackViewDelegate

public protocol FeedbackViewDelegate: AnyObject {
    func feedbackView(
        _ feedbackView: FeedbackView,
        didSelectButtonOfType buttonType: FeedbackView.ButtonType,
        forStep stepIdentifier: String
    )
}

// MARK: - FeedbackView

public class FeedbackView: UIView {
    public enum ButtonType {
        case positive
        case negative
    }

    // MARK: - Public properties

    public weak var delegate: FeedbackViewDelegate?

    // MARK: - Private properties

    private var hasBeenPresented = false
    private var stepIdentifier: String = ""
    private var presentation: FeedbackViewPresentation?
    private var allowAutomaticPresentationSwitch: Bool = true

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .pusefinnCircle)
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
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),
        imageGridHeightConstraint,
        titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Warp.Spacing.spacing100),
        titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),
        buttonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),
        buttonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Warp.Spacing.spacing200)
    ]

    private lazy var listPresentationConstraints: [NSLayoutConstraint] = [
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Warp.Spacing.spacing100),
        imageView.widthAnchor.constraint(equalToConstant: 130),
        imageListHeightConstraint,
        titleView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing100),
        titleView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Warp.Spacing.spacing100),
        buttonView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Warp.Spacing.spacing100),
        buttonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Warp.Spacing.spacing100)
    ]

    private lazy var imageListHeightConstraint = imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
    private lazy var imageGridHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 130)

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
        backgroundColor = .backgroundInfoSubtle

        layer.borderWidth = 1
        layer.cornerRadius = 8
        layer.masksToBounds = true

        addSubview(imageView)
        addSubview(titleView)
        addSubview(buttonView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing100),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),

            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),
            titleView.bottomAnchor.constraint(equalTo: buttonView.topAnchor, constant: -Warp.Spacing.spacing100),

            buttonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100)
        ])

        imageListHeightConstraint.priority = .required - 1
        imageGridHeightConstraint.priority = .required - 1
    }

    // MARK: - Public methods

    public func configureWithFixedPresentation(isGrid: Bool) {
        allowAutomaticPresentationSwitch = false
        let presentation: FeedbackViewPresentation = isGrid ? .grid : .list
        configure(forPresentation: presentation)
    }

    public func configure<T: RawRepresentable<String>>(stepIdentifier: T, viewModel: FeedbackViewModel) {
        configure(stepIdentifier: stepIdentifier.rawValue, viewModel: viewModel)
    }

    public func configure(stepIdentifier: String, viewModel: FeedbackViewModel) {
        self.stepIdentifier = stepIdentifier
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
        delegate?.feedbackView(self, didSelectButtonOfType: .positive, forStep: stepIdentifier)
    }

    @objc private func negativeButtonTapped() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        delegate?.feedbackView(self, didSelectButtonOfType: .negative, forStep: stepIdentifier)
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        hasBeenPresented = true

        layer.borderColor = .backgroundDisabled

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

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .bodyStrong
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.accessibilityTraits = .header
        return label
    }()

    private lazy var titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100)

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
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),
            heightAnchor.constraint(greaterThanOrEqualTo: titleLabel.heightAnchor)
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
            titleLabelLeadingConstraint.constant = Warp.Spacing.spacing100
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
        stackView.spacing = Warp.Spacing.spacing100
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
        setButtonTitles(positive: nil, negative: nil)

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
            borderWidth: 2.0,
            borderColor: .border
        )
    }
}
