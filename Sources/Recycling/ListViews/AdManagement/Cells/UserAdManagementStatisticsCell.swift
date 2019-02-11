//
//  Copyright © FINN.no AS. All rights reserved.
//

public class UserAdManagementStatisticsCell: UITableViewCell {
    public var itemModels = [StatisticsItemModel]() {
        didSet { updateStackViewContent() }
    }
    private lazy var stackView: UIStackView = {
        let view = UIStackView(withAutoLayout: true)
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()
    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .sardine
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func updateStackViewContent() {
        for oldSubview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(oldSubview)
        }
        let lastIndex = itemModels.count-1

        for (index, model) in itemModels.enumerated() {
            let itemView = StatisticsItemView(model: model)
            itemView.shouldShowLeftSeparator = index > 0 && index < lastIndex
            itemView.shouldShowRightSeparator = index > 0 && index < lastIndex
            // Slight overengineering, as there are currently no plans to receive any other number than three items
            if lastIndex == 1 { itemView.shouldShowLeftSeparator = index == lastIndex }
            if lastIndex > 2 { itemView.shouldShowRightSeparator = index == lastIndex-1 }
            stackView.addArrangedSubview(itemView)
            itemView.setupConstraints()
        }
    }

    private func setup() {
        contentView.addSubview(separatorView)
        contentView.addSubview(stackView)

        let hairLineSize = 1.0/UIScreen.main.scale

        NSLayoutConstraint.activate(
            [ separatorView.heightAnchor.constraint(equalToConstant: hairLineSize),
              separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
              separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
              separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
              stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
              stackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
              stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
              stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor) ]
        )
    }
}
