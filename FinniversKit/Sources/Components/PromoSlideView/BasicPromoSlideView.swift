import Foundation
import UIKit

public protocol BasicPromoSlideViewDelegate: AnyObject {
    func basicPromoSlideViewDidTapButton(_ basicPromoSlideView: BasicPromoSlideView)
}

public class BasicPromoSlideView: UIView {
    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    private lazy var button: Button = {
        let style = Button.Style.default.overrideStyle(
            bodyColor: .primaryBlue,
            borderColor: .white,
            textColor: .white,
            highlightedBodyColor: .primaryBlue,
            highlightedBorderColor: UIColor.white.withAlphaComponent(0.8),
            highlightedTextColor: UIColor.white.withAlphaComponent(0.8)
        )
        let button = Button(style: style, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var imageView = UIImageView(withAutoLayout: true)

    public weak var delegate: BasicPromoSlideViewDelegate?

    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(button)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),

            button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS + .spacingXS),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            button.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),

            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor)
        ])
    }

    public func configure(with text: String, buttonTitle: String, image: UIImage) {
        titleLabel.text = text
        button.setTitle(buttonTitle, for: .normal)
        imageView.image = image
    }

    @objc private func handleButtonTap() {
        delegate?.basicPromoSlideViewDidTapButton(self)
    }
}
