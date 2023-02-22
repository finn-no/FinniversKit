//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

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

    private lazy var stackView = UIStackView(axis: .horizontal, spacing: .spacingM, alignment: .center, distribution: .fill, withAutoLayout: true)

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.font = NeighborhoodProfileHeaderView.titleFont
        label.textColor = .textPrimary
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
            tintColor = isHighlighted ? .linkButtonHighlightedTextColor : .btnPrimary
        }
    }

    public override var isSelected: Bool {
        didSet {
            tintColor = isSelected ? .linkButtonHighlightedTextColor : .btnPrimary
        }
    }

    private func setup() {
        tintColor = .btnPrimary
        semanticContentAttribute = .forceRightToLeft

        titleLabel?.font = .captionStrong
        setTitleColor(.btnPrimary, for: .normal)
        setTitleColor(.linkButtonHighlightedTextColor, for: .highlighted)

        setImage(UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate), for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 3, leading: .spacingXS, bottom: 3, trailing: -.spacingXS)
        imageView?.contentMode = .scaleAspectFit
        adjustsImageWhenHighlighted = false
    }
}
