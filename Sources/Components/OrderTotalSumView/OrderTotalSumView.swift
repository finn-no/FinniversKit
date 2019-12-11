//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public class OrderTotalSumView: UIView {
    // MARK: Private properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textAlignment = .left
        return label
    }()

    private lazy var totalSumLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textAlignment = .right
        return label
    }()

    // MARK: Public properties

    public var totalSum: String {
        didSet {
            totalSumLabel.text = totalSum
        }
    }

    // MARK: Initalizer

    public init(title: String, totalSum: String, withAutoLayout: Bool = false) {
        self.totalSum = totalSum

        super.init(frame: .zero)

        titleLabel.text = title
        totalSumLabel.text = totalSum

        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        backgroundColor = .bgPrimary

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private methods

private extension OrderTotalSumView {
    func setup() {
        addSubview(titleLabel)
        addSubview(totalSumLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),

            totalSumLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            totalSumLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            totalSumLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
