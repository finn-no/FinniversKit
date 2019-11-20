//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol SelectorTitleViewDelegate: AnyObject {
    func selectorTitleViewDidSelectButton(_ view: SelectorTitleView)
}

public class SelectorTitleView: UIView {
    // MARK: - Public

    public enum ArrowDirection {
        case up
        case down
    }

    public weak var delegate: SelectorTitleViewDelegate?

    public var arrowDirection: ArrowDirection = .down {
        didSet {
            updateArrowDirection()
        }
    }

    public var title: String? {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }

    public var arrowUpImage: UIImage?
    public var arrowDownImage: UIImage?

    // MARK: - Private

    private var isEnabled: Bool = true {
        didSet {
            button.isEnabled = isEnabled
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = UIFont.captionStrong.withSize(12).scaledFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.text = heading
        label.textColor = .textSecondary
        return label
    }()

    private lazy var button: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.titleLabel?.font = UIFont.bodyStrong.withSize(17).scaledFont(forTextStyle: .footnote)
        button.titleLabel?.adjustsFontForContentSizeCategory = true

        let spacing: CGFloat = .verySmallSpacing
        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: -spacing)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, leading: -spacing, bottom: 0, trailing: spacing)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)

        if heading != nil {
            button.contentEdgeInsets = UIEdgeInsets(
                top: titleLabel.font.pointSize,
                leading: .mediumLargeSpacing + spacing,
                bottom: 0,
                trailing: .mediumLargeSpacing + spacing
            )
        }

        return button
    }()

    private var heading: String?

    // MARK: - Init

    public init(heading: String) {
        self.heading = heading
        super.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        updateArrowDirection()

        backgroundColor = .bgPrimary

        updateButtonColor()
        addSubview(button)
        button.fillInSuperview()

        if heading != nil {
            addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

                button.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            ])
        }
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.selectorTitleViewDidSelectButton(self)
    }

    // MARK: - Public

    public func updateButtonColor(_ buttonColor: UIColor = .btnPrimary, buttonDisabledColor: UIColor = .btnDisabled) {
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonColor.withAlphaComponent(0.5), for: .highlighted)
        button.setTitleColor(buttonColor.withAlphaComponent(0.5), for: .selected)
        button.setTitleColor(buttonDisabledColor, for: .disabled)
        button.tintColor = buttonColor
    }

    // MARK: - Private

    private func updateArrowDirection() {
        if #available(iOS 13.0, *) {
            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .small)
            let image: UIImage?
            if arrowDirection == .up {
                image = arrowUpImage ?? UIImage(systemName: "chevron.up", withConfiguration: config)
            } else {
                image = arrowDownImage ?? UIImage(systemName: "chevron.down", withConfiguration: config)
            }
            button.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }

}
