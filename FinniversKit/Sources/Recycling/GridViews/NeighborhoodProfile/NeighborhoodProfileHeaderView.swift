//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

protocol NeighborhoodProfileHeaderViewDelegate: AnyObject {
    func neighborhoodProfileHeaderViewDidSelectButton(_ view: NeighborhoodProfileHeaderView)
}

final class NeighborhoodProfileHeaderView: UIView {
    static func height(forTitle title: String, width: CGFloat) -> CGFloat {
        return title.height(withConstrainedWidth: width, font: titleFont)
    }

    private static let titleFont = UIFont.title3

    // MARK: - Internal properties

    weak var delegate: NeighborhoodProfileHeaderViewDelegate?

    var title = "" {
        didSet { titleLabel.text = title }
    }

    var buttonTitle = "" {
        didSet { button.setTitle(buttonTitle, for: .normal) }
    }

    // MARK: - Private properties

    private lazy var stackView = UIStackView(axis: .horizontal, spacing: Warp.Spacing.spacing200, alignment: .center, distribution: .fill, withAutoLayout: true)

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.font = NeighborhoodProfileHeaderView.titleFont
        label.textColor = .text
        return label
    }()

    private lazy var button: UIButton = {
        let button = ArrowButton(withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubviews([titleLabel, UIView(), button])
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.neighborhoodProfileHeaderViewDidSelectButton(self)
    }
}

// MARK: - Private types

private final class ArrowButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .backgroundActive : .clear
        }
    }

    public override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .backgroundActive : .clear
        }
    }

    private func setup() {
        tintColor = .textLink
        semanticContentAttribute = .forceRightToLeft

        titleLabel?.font = .captionStrong
        setTitleColor(.textLink, for: .normal)
        setTitleColor(.textLink, for: .highlighted)

        let image = UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
        imageEdgeInsets = UIEdgeInsets(top: 3, leading: .spacingXS, bottom: 3, trailing: -.spacingXS)
        contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layer.cornerRadius = 8
        imageView?.contentMode = .scaleAspectFit
    }
}
