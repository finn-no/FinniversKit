//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

final class PhaseView: UIView {
    private static let regularDotSize: CGFloat = 12
    private static let highlightedDotSize: CGFloat = 19

    // MARK: - Internal properties

    private(set) lazy var dotView = UIView(withAutoLayout: true)

    // MARK: - Private properties

    private lazy var textLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()

    private lazy var dotViewWidthConstraint = dotView.widthAnchor.constraint(equalToConstant: 0)
    private lazy var textLabelTopConstraint = textLabel.topAnchor.constraint(equalTo: dotView.centerYAnchor)

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

    func configure(with viewModel: PhaseViewModel) {
        let dotWidth = viewModel.isHighlighted ? PhaseView.highlightedDotSize : PhaseView.regularDotSize

        dotView.backgroundColor = viewModel.isHighlighted ? .secondaryBlue : .sardine
        dotView.layer.borderColor = viewModel.isHighlighted ? .secondaryBlue : nil
        dotView.layer.borderWidth = viewModel.isHighlighted ? 3 : 0
        dotView.layer.cornerRadius = dotWidth / 2
        dotViewWidthConstraint.constant = dotWidth

        textLabel.attributedText = viewModel.attributedText
        textLabelTopConstraint.constant = viewModel.isHighlighted ? -dotWidth / 2 : -.mediumSpacing

        layoutIfNeeded()
    }

    private func setup() {
        addSubview(dotView)
        addSubview(textLabel)

        let dotWidth = PhaseView.highlightedDotSize
        let textLabelLeadingConstraint = textLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: dotWidth * 3 / 2
        )

        textLabelLeadingConstraint.priority = UILayoutPriority(rawValue: 999)

        NSLayoutConstraint.activate([
            dotView.topAnchor.constraint(equalTo: topAnchor),
            dotView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: dotWidth / 2),
            dotView.heightAnchor.constraint(equalTo: dotView.widthAnchor),
            dotViewWidthConstraint,

            textLabelTopConstraint,
            textLabelLeadingConstraint,
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Private extensions

private extension PhaseViewModel {
    var attributedText: NSAttributedString {
        let detailText = " - \(self.detailText)"
        let text = title + detailText
        let attributedString = NSMutableAttributedString(string: text)

        if let range = text.range(of: title) {
            let font: UIFont = isHighlighted ? .bodyStrong : .detailStrong
            attributedString.addAttributes([.font: font], range: NSRange(range, in: text))
        }

        if let range = text.range(of: detailText) {
            attributedString.addAttributes([.font: UIFont.detail], range: NSRange(range, in: text))
        }

        return attributedString
    }
}
