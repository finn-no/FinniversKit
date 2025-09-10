import UIKit
import Warp

public class FrontPageHeaderView: UICollectionReusableView {
    public typealias ButtonAction = (() -> Void)

    private lazy var titleLabel: UILabel = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 2
        label.accessibilityTraits.insert(.header)
        return label
    }()

    private lazy var button: UIButton = {
        let button = Button(
            style: .flat.overrideStyle(
                margins: .init(
                    top: Warp.Spacing.spacing100,
                    leading: isAccessibilityCategory ? 0 : Warp.Spacing.spacing200,
                    bottom: Warp.Spacing.spacing100,
                    trailing: 0
                )
            )
        )
        button.size = .normal
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()

    private lazy var isAccessibilityCategory: Bool = traitCollection.preferredContentSizeCategory.isAccessibilityCategory

    public required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    private var buttonTitle: String = "" {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
        }
    }

    private var buttonAction: ButtonAction?

    public func configureHeaderView(withTitle title: String, buttonTitle: String, buttonAction: @escaping ButtonAction) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
    }

    private func setup() {
        titleLabel.text = title
        button.setTitle(buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = isAccessibilityCategory ? .vertical : .horizontal
        stackView.distribution = .fill
        stackView.alignment = isAccessibilityCategory ? .leading : .fill
        stackView.addArrangedSubviews([titleLabel, button])

        addSubview(stackView)
        stackView.fillInSuperview()
    }

    @objc private func buttonTapped() {
        buttonAction?()
    }
}
