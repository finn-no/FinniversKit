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

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var viewingStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
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

    private lazy var weekdayTimeStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = .spacingXXS
        return stackView
    }()

    private lazy var dayLabel = Label(style: .title3, withAutoLayout: true)

    private lazy var weekdayLabel = Label(style: .body, withAutoLayout: true)

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

    private lazy var noteLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textColor = .textSecondary
        label.numberOfLines = 0
        return label
    }()

    private let noteBottomPadding: CGFloat = .spacingM
    static let dateViewWidth: CGFloat = 48.0
    static let viewingStackViewHeight: CGFloat = 60.0
    static let contentSpacing: CGFloat = .spacingS

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
        contentView.addSubview(contentStackView)
        contentStackView.fillInSuperview()

        backgroundColor = .bgPrimary

        contentStackView.addArrangedSubview(viewingStackView)
        contentStackView.addArrangedSubview(noteLabel)

        viewingStackView.addArrangedSubview(dateStackView)
        viewingStackView.addArrangedSubview(weekdayTimeStackView)
        viewingStackView.addArrangedSubview(addToCalendarButton)

        dateStackView.addArrangedSubview(monthLabel)
        dateStackView.addArrangedSubview(dayLabel)

        weekdayTimeStackView.addArrangedSubview(weekdayLabel)
        weekdayTimeStackView.addArrangedSubview(timeLabel)

        NSLayoutConstraint.activate([
            viewingStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: ViewingCell.viewingStackViewHeight),
            viewingStackView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            noteLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: ViewingCell.dateViewWidth + ViewingCell.contentSpacing),
            dateStackView.widthAnchor.constraint(equalToConstant: ViewingCell.dateViewWidth),
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: ViewingCellViewModel, addToCalendarButtonTitle: String, topEdgeInset: CGFloat = 0) {
        weekdayLabel.text = viewModel.weekday
        monthLabel.text = viewModel.month
        dayLabel.text = viewModel.day
        addToCalendarButton.setTitle(addToCalendarButtonTitle, for: .normal)

        if let timeInterval = viewModel.timeInterval {
            timeLabel.text = timeInterval
        } else {
            timeLabel.isHidden = true
        }

        var bottomMargin: CGFloat = 0
        if let note = viewModel.note {
            noteLabel.text = note
            bottomMargin = noteBottomPadding
        } else {
            noteLabel.isHidden = true
        }

        if bottomMargin > 0 || topEdgeInset > 0 {
            contentStackView.layoutMargins = UIEdgeInsets(top: topEdgeInset, bottom: bottomMargin)
        }
    }

    // MARK: - Internal methods

    func heightNeeded(for width: CGFloat, note: String?) -> CGFloat {
        var noteHeight: CGFloat = 0
        if let note = note {
            noteLabel.text = note
            noteHeight = noteLabel.sizeThatFits(CGSize(width: width - ViewingCell.dateViewWidth - ViewingCell.contentSpacing, height: CGFloat.greatestFiniteMagnitude)).height
            noteHeight += noteBottomPadding
        }
        return ViewingCell.viewingStackViewHeight + noteHeight
    }

    // MARK: - Private methods

    @objc func addToCalendarButtonTapped() {
        delegate?.viewingCellDidSelectAddToCalendarButton(self)
    }
}
