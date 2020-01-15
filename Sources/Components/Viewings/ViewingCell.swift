//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

protocol ViewingCellDelegate: AnyObject {
    func viewingCellDidSelectAddToCalendarButton(_ cell: ViewingCell)
}

class ViewingCell: UITableViewCell {
    weak var delegate: ViewingCellDelegate?

    // MARK: - Private properties

    private lazy var viewingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = ViewingCell.contentSpacing
        stackView.alignment = .center
        return stackView
    }()

    private lazy var dateStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()

    private lazy var monthLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .textCritical
        return label
    }()

    private lazy var dayTimeStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = .verySmallSpacing
        return stackView
    }()

    private lazy var dateLabel = Label(style: .title3, withAutoLayout: true)

    private lazy var dayLabel = Label(style: .body, withAutoLayout: true)

    private lazy var timeLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .textSecondary
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var addToCalendarButton: Button = {
        let button = Button(style: .utility, size: .small, withAutoLayout: true)
        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        button.addTarget(self, action: #selector(addToCalendarButtonTapped), for: .touchUpInside)
        return button
    }()

    static let dateViewWidth: CGFloat = 56.0
    static let cellHeight: CGFloat = 64.0
    static let contentSpacing: CGFloat = .smallSpacing

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(viewingStackView)

        backgroundColor = .bgPrimary

        viewingStackView.fillInSuperview(insets: UIEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -.mediumSpacing), isActive: true)

        viewingStackView.addArrangedSubview(dateStackView)
        viewingStackView.addArrangedSubview(dayTimeStackView)
        viewingStackView.addArrangedSubview(addToCalendarButton)

        dateStackView.addArrangedSubview(monthLabel)
        dateStackView.addArrangedSubview(dateLabel)

        dayTimeStackView.addArrangedSubview(dayLabel)
        dayTimeStackView.addArrangedSubview(timeLabel)

        NSLayoutConstraint.activate([
            dateStackView.widthAnchor.constraint(equalToConstant: ViewingCell.dateViewWidth),
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: ViewingCellViewModel, addToCalendarButtonTitle: String) {
        if let timeInterval = viewModel.timeInterval {
            timeLabel.text = timeInterval
        } else {
            timeLabel.isHidden = true
        }
        dayLabel.text = viewModel.weekday
        monthLabel.text = viewModel.month
        dateLabel.text = viewModel.date
        addToCalendarButton.setTitle(addToCalendarButtonTitle, for: .normal)
    }

    // MARK: - Private methods

    @objc func addToCalendarButtonTapped() {
        delegate?.viewingCellDidSelectAddToCalendarButton(self)
    }
}
