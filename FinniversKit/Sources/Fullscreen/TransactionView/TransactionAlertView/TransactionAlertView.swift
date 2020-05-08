//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public class TransactionAlertView: UIView {
    enum Icon: String {
        case multipleContracts = "MULTIPLE-CONTRACTS"
        case `default` = "noImage"

        init(rawValue: String) {
            switch rawValue {
            case "MULTIPLE-CONTRACTS":
                self = .multipleContracts
            default:
                self = .default
            }
        }

        var icon: UIImage {
            switch self {
            case .multipleContracts:
                return UIImage(named: .multipleContracts)
            case .default:
                return UIImage(named: .noImage)
            }
        }
    }

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .textToast
        label.numberOfLines = 0
        return label
    }()

    private lazy var messageView: UITextView = {
        let view = UITextView(withAutoLayout: true)
        let style = Label.Style.caption
        view.font = style.font
        view.textColor = .textToast
        view.backgroundColor = .clear
        view.contentInset = .leadingInset(-.spacingXS)
        view.isScrollEnabled = false
        view.isEditable = false
        view.isUserInteractionEnabled = false
        view.adjustsFontForContentSizeCategory = true
        view.textContainer.widthTracksTextView = true
        view.textContainer.heightTracksTextView = true
        return view
    }()

    private lazy var iconImageView: UIImageView = {
        let image = Icon(rawValue: model.imageIdentifier).icon
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = .spacingM
        return imageView
    }()

    private static var iconImageSize: CGFloat = 96
    private var loadingColor: UIColor = .accentToothpaste

    private var model: TransactionAlertViewModel

    public init(withAutoLayout autoLayout: Bool = false, model: TransactionAlertViewModel) {
        self.model = model

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !autoLayout

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .bgAlert
        layer.cornerRadius = .spacingS

        titleLabel.text = model.title
        messageView.text = model.message

        addSubview(titleLabel)
        addSubview(messageView)
        addSubview(iconImageView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),

            messageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            messageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXXS),

            iconImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingM),
            iconImageView.widthAnchor.constraint(equalToConstant: TransactionAlertView.iconImageSize),
            iconImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: messageView.bottomAnchor),

            bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: .spacingS),
        ])

        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        messageView.setContentHuggingPriority(.required, for: .vertical)
    }
}
