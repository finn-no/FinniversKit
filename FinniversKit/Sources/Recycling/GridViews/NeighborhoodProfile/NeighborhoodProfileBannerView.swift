//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol NeighborhoodProfileBannerViewDelegate: AnyObject {
    func neighborhoodProfileHeaderViewDidSelectButton(_ view: NeighborhoodProfileHeaderView)
}

final class NeighborhoodProfileBannerView: UIView {
//    static func height(forTitle title: String, width: CGFloat) -> CGFloat {
//        return title.height(withConstrainedWidth: width, font: titleFont)
//    }
//
//    private static let titleFont = UIFont.title3

    // MARK: - Internal properties

    var text = "Lurer du på hvor langt det er til et sted som kanskje selger pizza?" {
        didSet { textLabel.setText(fromHTMLString: text) }
    }
    
    var buttonText = "Se reisetider" {
        didSet { button.setTitle(buttonText, for: .normal) }
    }
    

    // MARK: - Private properties
    
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.layer.borderWidth = 1
        stack.layer.borderColor = .imageBorder
        stack.layer.cornerRadius = .spacingS
        stack.layer.masksToBounds = true
        stack.axis = .vertical
        stack.spacing = .spacingM
        stack.alignment = .fill
        stack.backgroundColor = .bgPrimary
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(all: .spacingM)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private lazy var textLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.setText(fromHTMLString: text)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var button: Button = {
        let button = Button(style: .default, size: .normal, withAutoLayout: true)
        button.setTitle(buttonText, for: .normal)
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
        containerStackView.addArrangedSubviews([textLabel, button])
        addSubview(containerStackView)

        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
