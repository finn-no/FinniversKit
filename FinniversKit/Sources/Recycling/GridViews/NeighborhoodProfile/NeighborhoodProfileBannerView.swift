//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol NeighborhoodProfileBannerViewDelegate: AnyObject {
    func neighborhoodProfileBannerDidSelectButton(_ view: NeighborhoodProfileBannerView)
}

final class NeighborhoodProfileBannerView: UIView {
//    static func height(forTitle title: String, width: CGFloat) -> CGFloat {
//        return title.height(withConstrainedWidth: width, font: titleFont)
//    }
//
//    private static let titleFont = UIFont.title3

    // MARK: - Internal properties

    weak var delegate: NeighborhoodProfileBannerViewDelegate?
    
    var text = "" {
        didSet {
            textLabel.setHTMLText(text)
            textLabel.textAlignment = .center
        }
    }
    
    var buttonText = "" {
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
        stack.backgroundColor = .bgPrimary
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(all: .spacingM)
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private lazy var textLabel: HTMLLabel = {
        let label = HTMLLabel(style: .body, withAutoLayout: true)
        label.setHTMLText(text)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var button: Button = {
        let button = Button(style: .default, size: .normal, withAutoLayout: true)
        button.setTitle(buttonText, for: .normal)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
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
        containerStackView.fillInSuperview()
    }
    
    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.neighborhoodProfileBannerDidSelectButton(self)
    }
}
