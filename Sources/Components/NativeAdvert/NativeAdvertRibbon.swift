//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public struct NativeAdvertRibbonViewModel {
    let type: String
    let company: String?

    public init(type: String, company: String?) {
        self.type = type
        self.company = company
    }
}

class NativeAdvertRibbon: UIView {

    // MARK: - Private properties

    private lazy var typeLabelContainer: UIView = {
        let view = UIView(withAutoLayout: true)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        view.layer.borderWidth = 1
        view.layer.borderColor = .tableViewSeparator
        view.layer.cornerRadius = .smallSpacing
        return view
    }()

    private lazy var typeLabel: UILabel = {
        let view = Label(style: .detail, withAutoLayout: true)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return view
    }()

    private lazy var companyLabel: UILabel = {
        let view = Label(style: .detail, withAutoLayout: true)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        view.textColor = .textAction
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(typeLabelContainer)
        addSubview(companyLabel)

        typeLabelContainer.addSubview(typeLabel)

        NSLayoutConstraint.activate([
            typeLabelContainer.topAnchor.constraint(equalTo: topAnchor),
            typeLabelContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            typeLabelContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            typeLabelContainer.trailingAnchor.constraint(equalTo: companyLabel.leadingAnchor, constant: -.smallSpacing),

            typeLabel.topAnchor.constraint(equalTo: typeLabelContainer.topAnchor, constant: .verySmallSpacing),
            typeLabel.leadingAnchor.constraint(equalTo: typeLabelContainer.leadingAnchor, constant: .smallSpacing),
            typeLabel.bottomAnchor.constraint(equalTo: typeLabelContainer.bottomAnchor, constant: -.verySmallSpacing),
            typeLabel.trailingAnchor.constraint(equalTo: typeLabelContainer.trailingAnchor, constant: -.verySmallSpacing),

            companyLabel.centerYAnchor.constraint(equalTo: typeLabelContainer.centerYAnchor),
            companyLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    // MARK: - Public methods

    func configure(with model: NativeAdvertRibbonViewModel) {
        typeLabel.text = model.type
        companyLabel.text = model.company
    }

}
