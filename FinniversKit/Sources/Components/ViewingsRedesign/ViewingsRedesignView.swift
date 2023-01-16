import UIKit

public protocol ViewingsRedesignViewDelegate: AnyObject {
    func viewingsRedesignView(_ view: ViewingsRedesignView, didSelectButton selectedButton: ViewingsRedesignView.SelectedButton)
}

public class ViewingsRedesignView: UIView {

    // MARK: - Private properties

    private let viewModel: ViewingsRedesignViewModel
    private weak var delegate: ViewingsRedesignViewDelegate?
    private lazy var titleLabel = Label(style: .title3, numberOfLines: 0, withAutoLayout: true)
    private lazy var moreInfoLabel = Label(style: .caption, numberOfLines: 0, withAutoLayout: true)
    private lazy var prospectusDescriptionLabel = Label(style: .body, numberOfLines: 0, withAutoLayout: true)
    private lazy var prospectusStackView = UIStackView(axis: .vertical, withAutoLayout: true)
    private lazy var viewingsStackView = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)

    private lazy var stackView: UIStackView = {
        let view = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(all: .spacingM)
        return view
    }()

    private lazy var prospectusButton: MultilineButton = {
        let button = MultilineButton(style: .prospectusButtonStyle, size: .normal, withAutoLayout: true)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(all: 0)
        button.addTarget(self, action: #selector(prospectusButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var viewingSignupButton: Button = {
        let button = Button(style: .callToAction)
        button.addTarget(self, action: #selector(viewingSignupButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public init(
        viewModel: ViewingsRedesignViewModel,
        delegate: ViewingsRedesignViewDelegate,
        withAutoLayout: Bool
    ) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        layer.cornerRadius = .spacingS
        layer.borderWidth = 1

        addSubview(stackView)
        stackView.fillInSuperview()

        prospectusStackView.addArrangedSubviews([prospectusDescriptionLabel, prospectusButton,])
        stackView.addArrangedSubviews([
            titleLabel,
            viewingsStackView,
            moreInfoLabel,
            prospectusStackView,
            viewingSignupButton
        ])

        stackView.setCustomSpacing(.zero, after: viewingsStackView)
        stackView.setCustomSpacing(.spacingM, after: moreInfoLabel)
        stackView.setCustomSpacing(.spacingM, after: prospectusStackView)
        stackView.setCustomSpacing(.spacingM, after: viewingSignupButton)

        titleLabel.text = viewModel.title
        moreInfoLabel.text = viewModel.moreInfoText
        moreInfoLabel.isHidden = viewModel.moreInfoText == nil

        if let button = viewModel.prospectusButton {
            prospectusDescriptionLabel.text = button.description
            prospectusButton.setTitle(button.title, for: .normal)
        } else {
            prospectusStackView.isHidden = true
        }

        if let button = viewModel.viewingSignupButton {
            viewingSignupButton.setTitle(button.title, for: .normal)
        } else {
            viewingSignupButton.isHidden = true
        }

        viewModel.viewings.enumerated().forEach { index, viewing in
            let view = ViewingItemView(layout: .redesign, withAutoLayout: true)
            view.configure(
                with: viewing,
                addToCalendarButtonTitle: viewModel.addToCalendarButtonTitle,
                showSeparator: index != viewModel.viewings.count - 1,
                topEdgeInset: 0
            )

            view.delegate = self

            viewingsStackView.addArrangedSubview(view)
        }
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = .borderDefault
    }

    // MARK: - Actions

    @objc private func prospectusButtonTapped() {
        guard let prospectusButton = viewModel.prospectusButton else { return }
        delegate?.viewingsRedesignView(self, didSelectButton: .prospectus(url: prospectusButton.url))
    }

    @objc private func viewingSignupButtonTapped() {
        guard let viewingSignupButton = viewModel.viewingSignupButton else { return }
        delegate?.viewingsRedesignView(self, didSelectButton: .viewingSignup(url: viewingSignupButton.url))
    }
}

// MARK: - Nested types

extension ViewingsRedesignView {
    public enum SelectedButton {
        case viewing(index: Int)
        case viewingSignup(url: String)
        case prospectus(url: String)
    }
}

// MARK: - Private extensions

private extension Button.Style {
    static var prospectusButtonStyle: Button.Style {
        Button.Style.flat.overrideStyle(
            margins: UIEdgeInsets(all: 0)
        )
    }
}

// MARK: - ViewingItemViewDelegate

extension ViewingsRedesignView: ViewingItemViewDelegate {
    func viewingItemViewDidSelectAddToCalendarButton(_ view: ViewingItemView) {
        guard let index = viewingsStackView.arrangedSubviews.firstIndex(of: view) else {
            return
        }

        delegate?.viewingsRedesignView(self, didSelectButton: .viewing(index: index))
    }
}
