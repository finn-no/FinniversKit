import UIKit

public class FrontPageHeaderView: UICollectionReusableView {
    public typealias ButtonAction = (()->())

    private lazy var titleLabel: UILabel = {
        let label = Label(style: .title3Strong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        label.accessibilityTraits.insert(.header)
        return label
    }()

    private lazy var button: UIButton = {
        let button = Button(
            style: .flat.overrideStyle(
                margins: .init(top: .spacingS, leading: .spacingM, bottom: .spacingS, trailing: 0)
            )
        )
        button.size = .normal
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()

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

        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fill
        horizontalStack.addArrangedSubviews([titleLabel, button])

        addSubview(horizontalStack)
        horizontalStack.fillInSuperview()

    }

    @objc private func buttonTapped() {
        buttonAction?()
    }
}
