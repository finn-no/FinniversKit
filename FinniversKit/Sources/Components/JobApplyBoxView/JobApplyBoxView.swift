import UIKit

public protocol JobApplyBoxViewDelegate: AnyObject {
    func jobApplyBoxView(
        _ view: JobApplyBoxView,
        didSelectButton selectedButton: JobApplyBoxView.SelectedButton,
        withURL url: URL,
        viewModel: JobApplyBoxViewModel
    )
}

public class JobApplyBoxView: UIView {
    public enum SelectedButton {
        case primary
        case secondary
    }

    // MARK: - Private properties

    private let viewModel: JobApplyBoxViewModel
    private weak var delegate: JobApplyBoxViewDelegate?
    private lazy var stackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var primaryButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public init(viewModel: JobApplyBoxViewModel, delegate: JobApplyBoxViewDelegate, withAutoLayout: Bool) {
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
        backgroundColor = .backgroundInfoSubtle
        titleLabel.text = viewModel.title
        primaryButton.setTitle(viewModel.primaryButton.title, for: .normal)

        stackView.addArrangedSubviews([titleLabel, primaryButton])

        if let secondaryButton = viewModel.secondaryButton {
            let linkButton = LinkButtonView(
                buttonTitle: secondaryButton.title,
                linkUrl: secondaryButton.url,
                isExternal: true,
                buttonStyle: .secondaryButton,
                buttonSize: .normal
            )
            linkButton.delegate = self
            stackView.addArrangedSubview(linkButton)
        }

        addSubview(stackView)
        stackView.fillInSuperview(margin: .spacingL)
    }

    // MARK: - Actions

    @objc private func primaryButtonTapped() {
        delegate?.jobApplyBoxView(self, didSelectButton: .primary, withURL: viewModel.primaryButton.url, viewModel: viewModel)
    }
}

// MARK: - LinkButtonViewDelegate

extension JobApplyBoxView: LinkButtonViewDelegate {
    func linkButton(withIdentifier identifier: String?, wasTappedWithUrl url: URL) {
        delegate?.jobApplyBoxView(self, didSelectButton: .secondary, withURL: url, viewModel: viewModel)
    }
}

// MARK: - Private extensions

private extension Button.Style {
    static var secondaryButton: Self {
        .flat.overrideStyle(margins: UIEdgeInsets(vertical: .spacingS, horizontal: 0))
    }
}
