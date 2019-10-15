//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

protocol SubtitleViewDelegate: AnyObject {
    func subtitleView(_ view: SubtitleView, didSelectButton button: UIButton)
}

final class SubtitleView: UIView {
    weak var delegate: SubtitleViewDelegate?

    private(set) lazy var label: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textAlignment = .center
        label.textColor = .licorice
        return label
    }()

    private(set) lazy var button: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.isHidden = true
        button.titleLabel?.font = .captionStrong
        button.setTitleColor(.btnPrimary, for: .normal)
        button.setTitleColor(.linkButtonHighlightedTextColor, for: .highlighted)
        button.setTitleColor(.linkButtonHighlightedTextColor, for: .selected)
        button.addTarget(self, action: #selector(handleShareButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var contentView = UIView(withAutoLayout: true)
    private lazy var labelTrailingConstraint = label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    private lazy var buttonTrailingConstraint = button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

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

    func configure(withText text: String, buttonTitle: String) {
        button.isHidden = buttonTitle.isEmpty
        button.setTitle(buttonTitle, for: .normal)

        if !text.isEmpty && !buttonTitle.isEmpty {
            label.text = "\(text)・"
            labelTrailingConstraint.isActive = false
            buttonTrailingConstraint.isActive = true
        } else {
            label.text = text
            labelTrailingConstraint.isActive = true
            buttonTrailingConstraint.isActive = false
        }
    }

    private func setup() {
        addSubview(contentView)
        contentView.addSubview(label)
        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),

            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            labelTrailingConstraint,

            button.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            button.leadingAnchor.constraint(equalTo: label.trailingAnchor),
        ])
    }

    // MARK: - Actions

    @objc private func handleShareButtonTap() {
        delegate?.subtitleView(self, didSelectButton: button)
    }
}
