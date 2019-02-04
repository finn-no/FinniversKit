//
//  Copyright © FINN.no AS. All rights reserved.
//

import UIKit

class StatisticsItemView: UIView {
    lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        return UIImageView()
    }()

    lazy var valueLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.font = UIFont.title2 // subject to change medium/26 seems closer to the sketches
        label.textColor = .licorice
        label.textAlignment = .center
        return label
    }()

    lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont.caption
        label.textColor = .licorice
        label.textAlignment = .center
        return label
    }()

    lazy var leftSeparator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .sardine
        return view
    }()

    lazy var rightSeparator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .sardine
        return view
    }()

    var shouldShowLeftSeparator: Bool = false {
        didSet { leftSeparator.isHidden = !shouldShowLeftSeparator }
    }
    var shouldShowRightSeparator: Bool = false {
        didSet { rightSeparator.isHidden = !shouldShowRightSeparator }
    }

    var itemModel: StatisticsItemModel? {
        didSet {
            guard let model = itemModel else { return }

            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.locale = Locale(identifier: "nb_NO")
            let valueString = formatter.string(for: model.value) ?? "\(model.value)"

            valueLabel.attributedText = NSAttributedString(string: valueString)
            textLabel.attributedText = NSAttributedString(string: model.text)

            var image: UIImage? {
                switch model.type {
                case .email:
                    return UIImage(named: .favoriteAdd)
                case .seen:
                    return UIImage(named: .favoriteAdd)
                case .favourited:
                    return UIImage(named: .favoriteAdd)
                }
            }
            imageView.image = image
        }
    }

    func setup() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftSeparator)
        leftSeparator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightSeparator)
        rightSeparator.translatesAutoresizingMaskIntoConstraints = false

        let hairLineConstant = 1.0/UIScreen.main.scale

        NSLayoutConstraint.activate(
            [ imageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
              imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
              imageView.heightAnchor.constraint(equalToConstant: 40),
              imageView.widthAnchor.constraint(equalToConstant: 40),

              valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
              valueLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
              valueLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -.mediumLargeSpacing),

              textLabel.centerXAnchor.constraint(equalTo: valueLabel.centerXAnchor),
              textLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor),
              textLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -.largeSpacing),
              textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),

              leftSeparator.centerYAnchor.constraint(equalTo: centerYAnchor),
              leftSeparator.leftAnchor.constraint(equalTo: leftAnchor),
              leftSeparator.widthAnchor.constraint(equalToConstant: hairLineConstant),
              leftSeparator.heightAnchor.constraint(equalTo: heightAnchor, constant: -.veryLargeSpacing),

              rightSeparator.centerYAnchor.constraint(equalTo: centerYAnchor),
              rightSeparator.rightAnchor.constraint(equalTo: rightAnchor),
              rightSeparator.widthAnchor.constraint(equalToConstant: hairLineConstant),
              rightSeparator.heightAnchor.constraint(equalTo: heightAnchor, constant: -.veryLargeSpacing)
              ]
        )
    }
}
