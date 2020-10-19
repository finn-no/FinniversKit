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

    // MARK: - Private properties

    private var textItems: [String] = []

    private var style: Label.Style = .caption

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = .spacingM
        return stackView
    }()

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

    public func configure(with textItems: [String], numberOfColumns: Int, style: Label.Style) {
        self.textItems = textItems
        self.numberOfColumns = numberOfColumns
        self.style = style
        reconfigureColumns()
    }

    // MARK: - Private methods

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    private func reconfigureColumns() {
        stackView.removeArrangedSubviews()

        textItems
            .split(in: numberOfColumns)
            .forEach { elements in
                let columnStackView = createColumnStackView()

                elements.forEach { element in
                    columnStackView.addArrangedSubview(createLabel(with: element))
                }

                let numberOfMissingItems = textItems.chunkSize(forColumns: numberOfColumns) - elements.count
                (0..<numberOfMissingItems).forEach { _ in
                    columnStackView.addArrangedSubview(UIView())
                }

                stackView.addArrangedSubview(columnStackView)
            }
    }

    private func createColumnStackView() -> UIStackView {
        let columnStackView = UIStackView(withAutoLayout: true)
        columnStackView.axis = .vertical
        columnStackView.spacing = .spacingS

        return columnStackView
    }

    private func createLabel(with text: String) -> Label {
        let label = Label(style: style, withAutoLayout: true)
        label.text = text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        return label
    }
}
