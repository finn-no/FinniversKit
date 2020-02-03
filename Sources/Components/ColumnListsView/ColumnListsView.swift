//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import UIKit

public class ColumnListsView: UIView {
    // MARK: - Public properties

    public var numberOfColumns: Int = 2 {
        didSet {
            guard oldValue != numberOfColumns else {
                return
            }

            reconfigureColumns()
        }
    }

    public var font: UIFont = .caption {
        didSet {
            reconfigureColumns()
        }
    }

    // MARK: - Private properties

    private var textItems: [String] = []

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        return stackView
    }()

    private static let maxColumns: Int = 3

    private lazy var textViews: [UITextView] = (1...ColumnListsView.maxColumns).map({ _ in
        ColumnListsView.createTextView()
    })

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public methods

    public func configure(with textItems: [String], numberOfColumns: Int) {
        self.textItems = textItems
        self.numberOfColumns = numberOfColumns
        reconfigureColumns()
    }

    // MARK: - Private methods

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
        textViews.forEach({ stackView.addArrangedSubview($0) })
    }

    private func reconfigureColumns() {
        guard (1...ColumnListsView.maxColumns).contains(numberOfColumns) else {
            preconditionFailure(":(")
        }

        textViews.forEach({ $0.isHidden = true })

        textItems
            .split(in: numberOfColumns)
            .enumerated()
            .forEach { (column, elements) in
                let textView = textViews[column]
                textView.attributedText = elements.bulletPoints(withFont: font)
                textView.isHidden = false
        }
    }

    private static func createTextView(_ color: UIColor? = .clear) -> UITextView {
        let view = UITextView(withAutoLayout: true)
        view.isScrollEnabled = false
        view.isEditable = false
        view.backgroundColor = color
        return view
    }
}
