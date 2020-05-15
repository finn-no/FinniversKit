//
//  Copyright © 2020 FINN AS. All rights reserved.
//
import FinniversKit

public struct SavedSearchHeaderButtonModel {
    let text: String
    let highlightedRange: NSRange

    public init(text: String, highlightedRange: NSRange) {
        self.text = text
        self.highlightedRange = highlightedRange
    }
}

class SavedSearchHeaderButton: UIControl {

    // MARK: - Internal properties

    var centerTextAnchor: NSLayoutYAxisAnchor {
        textLabel.centerYAnchor
    }

    // MARK: - Private properties
    private lazy var magnifyingIconView: UIImageView = {
        let image = UIImage(named: .magnifyingGlass).withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .textPrimary
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        return imageView
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .captionStrong, withAutoLayout: true)
        label.numberOfLines = 1
        return label
    }()

    private lazy var arrowImageView: UIImageView = {
        let image = UIImage(named: .arrowRight).withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .textAction
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var highlightedRange: NSRange?
    private var attributedString: NSMutableAttributedString?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides
    override var isHighlighted: Bool {
        didSet {
            guard !isHighlighted, oldValue else { return }
            guard let range = highlightedRange else { return }
            attributedString?.removeAttribute(.underlineStyle, range: range)
            attributedString?.addAttribute(.foregroundColor, value: UIColor.textAction, range: range)
            textLabel.attributedText = attributedString
        }
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard super.beginTracking(touch, with: event) else { return false }
        guard let range = highlightedRange else { return false }
        attributedString?.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        attributedString?.addAttribute(.foregroundColor, value: UIColor.linkButtonHighlightedTextColor, range: range)
        textLabel.attributedText = attributedString
        return true
    }

    // MARK: - Internal methods
    func configure(with model: SavedSearchHeaderButtonModel?) {
        guard let model = model else {
            attributedString = nil
            textLabel.attributedText = nil
            self.highlightedRange = nil
            return
        }

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.captionStrong,
            .foregroundColor: UIColor.textPrimary
        ]

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.captionStrong,
            .foregroundColor: UIColor.textAction
        ]

        attributedString = NSMutableAttributedString(string: model.text, attributes: textAttributes)
        attributedString?.setAttributes(titleAttributes, range: model.highlightedRange)

        textLabel.attributedText = attributedString
        highlightedRange = model.highlightedRange
    }

    // MARK: - Private methods
    private func setup() {
        addSubview(magnifyingIconView)
        addSubview(textLabel)
        addSubview(arrowImageView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: 48),

            magnifyingIconView.leadingAnchor.constraint(equalTo: leadingAnchor),
            magnifyingIconView.bottomAnchor.constraint(equalTo: textLabel.firstBaselineAnchor, constant: 2),

            textLabel.leadingAnchor.constraint(equalTo: magnifyingIconView.trailingAnchor, constant: .spacingXXS),
            textLabel.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingS),

            arrowImageView.leadingAnchor.constraint(equalTo: textLabel.trailingAnchor, constant: .spacingXS),
            arrowImageView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 5),
            arrowImageView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
}
