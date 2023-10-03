//
//  Copyright © FINN.no AS. All rights reserved.
//

import UIKit

public protocol QuestionnaireViewDelegate: AnyObject {
    func questionnaireViewDidSelectPrimaryButton(_ view: QuestionnaireView)
    func questionnaireViewDidSelectCancelButton(_ view: QuestionnaireView)
}

public class QuestionnaireView: UIView {
    public weak var delegate: QuestionnaireViewDelegate?

    public private(set) var style: QuestionnaireView.Style

    public var model: QuestionnaireViewModel? {
        didSet {
            titleLabel.text = model?.title
            detailLabel.text = model?.detail
            primaryButton.setTitle(model?.buttonTitle, for: .normal)
        }
    }

    // MARK: - Subviews

    private lazy var titleLabel: UILabel = {
        let label = Label(style: style.titleStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .textPrimary
        return label
    }()

    private lazy var detailLabel: UILabel = {
        let label = Label(style: style.detailStyle)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var primaryButton: UIButton = {
        let button = Button(style: style.primaryButtonStyle, size: style.primaryButtonSize)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePrimaryButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var primaryButtonImageView: UIImageView? = {
        if let image = style.primaryButtonIcon {
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
        return nil
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        let imageView = UIImageView(image: UIImage(named: .remove).withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .textSecondary
        button.setImage(imageView.image, for: .normal)
        button.imageView?.tintColor = .textSecondary
        button.addTarget(self, action: #selector(handleCancelButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        style = .normal(backgroundColor: .bgSecondary, primaryButtonIcon: nil)
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        style = .normal(backgroundColor: .bgSecondary, primaryButtonIcon: nil)
        super.init(coder: aDecoder)
        setup()
    }

    public init(style: QuestionnaireView.Style) {
        self.style = style
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 8

        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(primaryButton)
        addSubview(cancelButton)

        var constraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            detailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            detailLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),

            primaryButton.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: .spacingM),
            primaryButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: .spacingXS),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXS),
        ]

        if let primaryButtonImageView = primaryButtonImageView {
            primaryButton.addSubview(primaryButtonImageView)
            let imageWidth: CGFloat = 18
            constraints.append(contentsOf: [
                primaryButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
                primaryButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
                primaryButtonImageView.widthAnchor.constraint(equalToConstant: imageWidth),
                primaryButtonImageView.heightAnchor.constraint(equalToConstant: imageWidth),
                primaryButtonImageView.centerYAnchor.constraint(equalTo: primaryButton.centerYAnchor),
                primaryButtonImageView.trailingAnchor.constraint(equalTo: primaryButton.trailingAnchor, constant: -.spacingM),
            ])
            primaryButton.titleEdgeInsets = UIEdgeInsets(top: primaryButton.titleEdgeInsets.top, leading: primaryButton.titleEdgeInsets.leading + .spacingM + imageWidth,
                                                         bottom: primaryButton.titleEdgeInsets.bottom, trailing: primaryButton.titleEdgeInsets.trailing + .spacingM + imageWidth)
        }

        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Actions

    @objc private func handlePrimaryButtonTap() {
        delegate?.questionnaireViewDidSelectPrimaryButton(self)
    }

    @objc private func handleCancelButtonTap() {
        delegate?.questionnaireViewDidSelectCancelButton(self)
    }
}
