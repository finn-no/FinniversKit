//
//  Copyright © FINN.no AS. All rights reserved.
//

import UIKit

class StatisticsItemView: UIView {

    // MARK: - Internal properties

    var shouldShowLeftSeparator: Bool = false {
        didSet { leftSeparator.isHidden = !shouldShowLeftSeparator }
    }

    var shouldShowRightSeparator: Bool = false {
        didSet { rightSeparator.isHidden = !shouldShowRightSeparator }
    }

    // MARK: - Private properties

    private let model: StatisticsItemModel

    private lazy var imageView: UIImageView = {
        let view = UIImageView(withAutoLayout: true)
        view.contentMode = .scaleAspectFit
        view.tintColor = .iconPrimary
        return view
    }()

    private lazy var valueLabel: Label = {
        let label = Label(style: .title2, withAutoLayout: true)
        label.textAlignment = .center
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .caption, numberOfLines: 0, withAutoLayout: true)
        label.textAlignment = .center
        return label
    }()

    private lazy var leftSeparator: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .textDisabled
        return view
    }()

    private lazy var rightSeparator: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .textDisabled
        return view
    }()

    // MARK: - Init

    init(model: StatisticsItemModel) {
        self.model = model
        super.init(frame: .zero)

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "nb_NO")
        let valueString = formatter.string(for: model.value) ?? "\(model.value)"

        valueLabel.attributedText = NSAttributedString(string: valueString)
        textLabel.attributedText = NSAttributedString(string: model.text)

        var image: UIImage? {
            switch model.type {
            case .email:
                return UIImage(named: .statsEnvelope).withRenderingMode(.alwaysTemplate)
            case .seen:
                return UIImage(named: .statsClick).withRenderingMode(.alwaysTemplate)
            case .favourited:
                return UIImage(named: .statsHeart).withRenderingMode(.alwaysTemplate)
            }
        }

        imageView.image = image
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Please use init(model:)")
    }

    override init(frame: CGRect) {
        fatalError("Please use init(model:)")
    }

    // MARK: - Private methods

    private func setup() {
        isAccessibilityElement = true
        accessibilityLabel = model.accessibilityLabel

        addSubview(imageView)
        addSubview(valueLabel)
        addSubview(textLabel)
        addSubview(leftSeparator)
        addSubview(rightSeparator)
    }

    // MARK: - Internal methods

    func setupConstraints() {
        let hairLineSize = 1.0/UIScreen.main.scale

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40),

            valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            valueLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            valueLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -.spacingM),

            textLabel.centerXAnchor.constraint(equalTo: valueLabel.centerXAnchor),
            textLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor),
            textLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -.spacingXL),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingM),

            leftSeparator.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftSeparator.leftAnchor.constraint(equalTo: leftAnchor),
            leftSeparator.widthAnchor.constraint(equalToConstant: hairLineSize),
            leftSeparator.heightAnchor.constraint(equalTo: heightAnchor, constant: -.spacingXXL),

            rightSeparator.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightSeparator.rightAnchor.constraint(equalTo: rightAnchor),
            rightSeparator.widthAnchor.constraint(equalToConstant: hairLineSize),
            rightSeparator.heightAnchor.constraint(equalTo: heightAnchor, constant: -.spacingXXL)])
    }
}
