//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
public typealias FrontPageHeaderViewButtonAction = (() -> Void)

public protocol ReuseIdentifiable {
    static var identifier: String { get }
}

public extension ReuseIdentifiable {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

public class FrontPageHeaderView: UICollectionReusableView, ReuseIdentifiable{
    
   // static let identifier = "FrontPageHeaderView"
    
    private lazy var titleLabel: UILabel = {
        let label = Label(style: .title3Strong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = Button(style: Button.Style.flat)
        button.size = .normal
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        return button
    }()
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private(set) var title: String = ""
    private(set) var buttonTitle: String = ""
    private(set) var buttonAction: FrontPageHeaderViewButtonAction?
    
    public func configureHeaderView(withTitle title: String, buttonTitle: String, buttonAction: @escaping FrontPageHeaderViewButtonAction) {
        self.title = title
        self.buttonTitle = buttonTitle
        self.buttonAction = buttonAction
        
        setup()
    }
    
    private func setup() {
        titleLabel.text = title
        button.setTitle(buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fill
        horizontalStack.addArrangedSubviews([titleLabel, button])
        
        addSubview(horizontalStack)
        horizontalStack.fillInSuperview()
        
    }
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
}
