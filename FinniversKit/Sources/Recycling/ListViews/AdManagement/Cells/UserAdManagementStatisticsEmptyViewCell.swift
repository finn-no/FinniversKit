//
//  Copyright © FINN.no AS. All rights reserved.
//

public class UserAdManagementStatisticsEmptyViewCell: UITableViewCell {

    // MARK: - Public

    public var itemModel: StatisticsItemEmptyViewModel? {
        didSet {
            guard let model = itemModel else { return }
            emptyView.model = model
        }
    }

    // MARK: - Private

    private lazy var emptyView: StatisticsItemEmptyView = {
        let view = StatisticsItemEmptyView(withAutoLayout: true)
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

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .background
        selectionStyle = .none
        addSubview(emptyView)

        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
