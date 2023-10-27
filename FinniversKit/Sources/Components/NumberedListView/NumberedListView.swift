import UIKit

public protocol NumberedListViewDelegate: AnyObject {
    func numberedListView(_ view: NumberedListView, didSelectActionButtonForItemAt itemIndex: Int)
}

public class NumberedListView: UIView {

    // MARK: - Public properties

    public weak var delegate: NumberedListViewDelegate?

    // MARK: - Private properties

    private let numberLabelStyle = Label.Style.bodyStrong
    private lazy var contentStackView = UIStackView(axis: .vertical, spacing: .spacingM, withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(contentStackView)
        contentStackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with items: [NumberedListItem]) {
        contentStackView.removeArrangedSubviews()

        let largestLabel = findLargestLabelWidth(itemCount: items.count)

        for (index, item) in items.enumerated() {
            let numberView = createNumberLabel(number: index + 1)

            let itemView = ListItemView(item: item, actionButtonHandler: { [weak self] in
                guard let self = self else { return }
                self.delegate?.numberedListView(self, didSelectActionButtonForItemAt: index)
            })

            let lineStackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
            lineStackView.alignment = .top
            lineStackView.addArrangedSubviews([numberView, itemView])

            numberView.widthAnchor.constraint(equalToConstant: largestLabel).isActive = true
            contentStackView.addArrangedSubview(lineStackView)
        }
    }

    // MARK: - Private methods

    private func findLargestLabelWidth(itemCount: Int) -> CGFloat {
        var largestLabel = CGFloat.zero

        for number in (1...itemCount) {
            let labelWidth = "\(number)".width(withConstrainedHeight: .infinity, font: numberLabelStyle.font)
            if labelWidth > largestLabel {
                largestLabel = labelWidth
            }
        }

        return largestLabel
    }

    private func createNumberLabel(number: Int) -> Label {
        let label = Label(style: numberLabelStyle, withAutoLayout: true)
        label.textColor = .textLink
        label.text = "\(number)"
        return label
    }
}

// MARK: - Private class

private class ListItemView: UIView {
    fileprivate typealias ButtonHandler = () -> Void
    private let actionButtonHandler: ButtonHandler?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, spacing: .spacingXS, withAutoLayout: true)
        stackView.addArrangedSubviews([titleLabel, bodyLabel])
        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private lazy var bodyLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var actionButton: Button = {
        let margins = UIEdgeInsets(top: .spacingS, left: .zero, bottom: .spacingS, right: .spacingM)
        let style = Button.Style.flat.overrideStyle(margins: margins)
        let button = Button(style: style, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    init(item: NumberedListItem, actionButtonHandler: ButtonHandler? = nil) {
        self.actionButtonHandler = actionButtonHandler
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.fillInSuperview()

        if let title = item.heading {
            titleLabel.text = title
            titleLabel.isHidden = false
        }

        if let buttonTitle = item.actionButtonTitle {
            actionButton.setTitle(buttonTitle, for: .normal)
            let buttonStackView = UIStackView(axis: .horizontal, withAutoLayout: true)
            buttonStackView.addArrangedSubviews([actionButton, UIView(withAutoLayout: true)])
            stackView.addArrangedSubview(buttonStackView)
        }

        bodyLabel.text = item.body
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        actionButtonHandler?()
    }
}
