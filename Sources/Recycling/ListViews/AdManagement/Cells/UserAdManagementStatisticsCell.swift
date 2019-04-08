//
//  Copyright © FINN.no AS. All rights reserved.
//

public class UserAdManagementStatisticsCell: UITableViewCell {

    // MARK: - Public

    public var itemModels = [StatisticsItemModel]() {
        didSet { updateStackViewContent() }
    }

    // MARK: - Private

    private lazy var emptyView: StatisticsItemEmptyView = {
        let view = StatisticsItemEmptyView(title: "Følg med på effekten", description: "Etter at du har publisert annonsen din kan du se statistikk for hvor mange som har sett annonsen din, favorisert den og som har fått tips om den.")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
            oldSubview.removeFromSuperview()
        }

        if itemModels.isEmpty {
            stackView.addArrangedSubview(emptyView)
        } else {
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
    }

    private func setup() {
        selectionStyle = .none
        contentView.addSubview(separatorView)
        contentView.addSubview(stackView)

        let hairLineSize = 1.0/UIScreen.main.scale

        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: hairLineSize),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            stackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
    }
}
