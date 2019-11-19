//
//  Copyright © FINN.no AS. All rights reserved.
//

public protocol UserAdManagementStatisticsCellDelegate: AnyObject {
    func userAdManagementStatisticsCellDidSelectFullStatistics(_ cell: UserAdManagementStatisticsCell)
}

public class UserAdManagementStatisticsCell: UITableViewCell {

    // MARK: - Public

    public weak var delegate: UserAdManagementStatisticsCellDelegate?

    // MARK: - Private

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var titleLabel: Label = Label(style: .bodyStrong, withAutoLayout: true)

    private lazy var fullStatisticsButton: Button = {
        let button = Button(style: .link, withAutoLayout: true)
        button.addTarget(self, action: #selector(fullStatisticsButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(withAutoLayout: true)
        view.alignment = .fill
        view.distribution = .fillEqually
        return view
    }()

    private lazy var separatorView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    // MARK: - Initalization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public methods
    public func configure(with model: StatisticsModel) {
        if let header = model.header {
            headerStackView.isHidden = false
            titleLabel.text = header.title
            fullStatisticsButton.setTitle(header.fullStatisticsTitle, for: .normal)
        } else {
            headerStackView.isHidden = true
        }

        updateStackViewContent(items: model.statisticItems)
    }

    // MARK: - Private methods

    private func updateStackViewContent(items: [StatisticsItemModel]) {
        for oldSubview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(oldSubview)
            oldSubview.removeFromSuperview()
        }

        let lastIndex = items.count-1
        for (index, model) in items.enumerated() {
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

    @objc private func fullStatisticsButtonTapped() {
        delegate?.userAdManagementStatisticsCellDidSelectFullStatistics(self)
    }

    private func setup() {
        selectionStyle = .none
        backgroundColor = .bgPrimary

        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(fullStatisticsButton)

        contentView.addSubview(separatorView)
        contentView.addSubview(headerStackView)
        contentView.addSubview(stackView)

        let hairLineSize = 1.0/UIScreen.main.scale

        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: hairLineSize),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            headerStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: .mediumSpacing),
            headerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            headerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            headerStackView.bottomAnchor.constraint(equalTo: stackView.topAnchor),

            stackView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)])
    }
}
