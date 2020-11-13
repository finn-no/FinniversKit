//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol SearchDisplayMenuViewDelegate: AnyObject {
    func searchDisplayMenuViewDidSelectSort()
    func searchDisplayMenuViewDidSelectChangeDisplayType()
}

public class SearchDisplayMenuView: UIView {
    private lazy var separatorLine: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    private lazy var sortButton: UIButton = createButton(
        with: UIImage(named: .sort),
        accessibilityLabel: sortAccessibilityLabel,
        action: #selector(sortButtonTapped)
    )

    private lazy var changeDisplayTypeButton: UIButton = createButton(
        with: UIImage(named: .pin),
        accessibilityLabel: changeDisplayTypeAccessibilityLabel,
        action: #selector(changeDisplayTypeButtonTapped)
    )

    private let sortAccessibilityLabel: String
    private let changeDisplayTypeAccessibilityLabel: String

    // MARK: - Public properties

    public weak var delegate: SearchDisplayMenuViewDelegate?
    public static let height: CGFloat = 44

    // MARK: - Init

    public init(
        sortAccessibilityLabel: String,
        changeDisplayTypeAccessibilityLabel: String,
        withAutoLayout: Bool = false
    ) {
        self.sortAccessibilityLabel = sortAccessibilityLabel
        self.changeDisplayTypeAccessibilityLabel = changeDisplayTypeAccessibilityLabel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary
        layer.cornerRadius = 22
        layer.borderWidth = 0.5

        addSubview(separatorLine)
        addSubview(sortButton)
        addSubview(changeDisplayTypeButton)

        dropShadow(color: .textPrimary, opacity: 0.20, offset: CGSize(width: 0, height: 4.5), radius: 13)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 128),
            heightAnchor.constraint(equalToConstant: SearchDisplayMenuView.height),

            sortButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXXS),
            sortButton.trailingAnchor.constraint(equalTo: separatorLine.leadingAnchor),
            sortButton.topAnchor.constraint(equalTo: topAnchor),
            sortButton.bottomAnchor.constraint(equalTo: bottomAnchor),

            separatorLine.centerXAnchor.constraint(equalTo: centerXAnchor),
            separatorLine.topAnchor.constraint(equalTo: topAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorLine.widthAnchor.constraint(equalToConstant: 1.0/UIScreen.main.scale),

            changeDisplayTypeButton.leadingAnchor.constraint(equalTo: separatorLine.trailingAnchor),
            changeDisplayTypeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXXS),
            changeDisplayTypeButton.topAnchor.constraint(equalTo: topAnchor),
            changeDisplayTypeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func createButton(with image: UIImage, accessibilityLabel: String, action: Selector) -> UIButton {
        let button = UIButton(withAutoLayout: true)
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .iconPrimary
        button.addTarget(self, action: action, for: .touchUpInside)
        button.isAccessibilityElement = true
        button.accessibilityLabel = accessibilityLabel
        return button
    }

    // MARK: - Lifecycle

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = .borderColor
    }

    // MARK: - Actions

    @objc private func sortButtonTapped() {
        delegate?.searchDisplayMenuViewDidSelectSort()
    }

    @objc private func changeDisplayTypeButtonTapped() {
        delegate?.searchDisplayMenuViewDidSelectChangeDisplayType()
    }
}

// MARK: - Private extensions

private extension CGColor {
    class var borderColor: CGColor {
        UIColor.dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine).cgColor
    }
}
