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
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()

    lazy var leftSeparator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        return view
    }()
    
    lazy var rightSeparator: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
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
            valueLabel.text = model.valueString
            textLabel.text = model.text

            var image: UIImage? {
                switch model.type {
                case .email:
                    return UIImage(named: "mailAd")
                case .seen:
                    return UIImage(named: "seenAd")
                case .favourited:
                    return UIImage(named: "favoriteAd")
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

        NSLayoutConstraint.activate(
            [ imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
              imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
              imageView.heightAnchor.constraint(equalToConstant: 50),
              imageView.widthAnchor.constraint(equalToConstant: 50),

              valueLabel.leftAnchor.constraint(equalTo: leftAnchor),
              valueLabel.rightAnchor.constraint(equalTo: rightAnchor),
              valueLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
              valueLabel.widthAnchor.constraint(equalTo: widthAnchor),

              textLabel.centerXAnchor.constraint(equalTo: valueLabel.centerXAnchor),
              textLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
              textLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),

              leftSeparator.centerYAnchor.constraint(equalTo: centerYAnchor),
              leftSeparator.leftAnchor.constraint(equalTo: leftAnchor),
              leftSeparator.widthAnchor.constraint(equalToConstant: 0.5),
              leftSeparator.heightAnchor.constraint(equalTo: heightAnchor, constant: -32),

              rightSeparator.centerYAnchor.constraint(equalTo: centerYAnchor),
              rightSeparator.rightAnchor.constraint(equalTo: rightAnchor),
              rightSeparator.widthAnchor.constraint(equalToConstant: 0.5),
              rightSeparator.heightAnchor.constraint(equalTo: heightAnchor, constant: -32) ]
        )
    }
}
