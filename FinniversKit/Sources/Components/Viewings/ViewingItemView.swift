import UIKit

protocol ViewingItemViewDelegate: AnyObject {
    func viewingItemViewDidSelectAddToCalendarButton(_ view: ViewingItemView)
}

class ViewingItemView: UIView {

    // MARK: - Internal properties

    weak var delegate: ViewingItemViewDelegate?

    // MARK: - Private properties

    private static let dateViewWidth: CGFloat = 48.0
    private static let viewingStackViewHeight: CGFloat = 60.0

    private let noteBottomMargin: CGFloat = .spacingM
    private lazy var dayLabel = Label(style: .title3, withAutoLayout: true)
    private lazy var weekdayLabel = Label(style: .body, withAutoLayout: true)
    private lazy var monthLabel = Label(style: .detail, textColor: .textCritical, withAutoLayout: true)
    private lazy var noteLabel = Label(style: .detail, numberOfLines: 0, textColor: .textSecondary, withAutoLayout: true)
    private lazy var viewingStackView = UIStackView(axis: .horizontal, spacing: .spacingS, alignment: .center, withAutoLayout: true)
    private lazy var dateStackView = UIStackView(axis: .vertical, alignment: .center, withAutoLayout: true)
    private lazy var weekdayTimeStackView = UIStackView(axis: .vertical, spacing: .spacingXXS, alignment: .leading, withAutoLayout: true)

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, alignment: .trailing, distribution: .fill, withAutoLayout: true)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var timeLabel: Label = {
        let label = Label(style: .detail, textColor: .textSecondary, withAutoLayout: true)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var addToCalendarButton: Button = {
        let button = Button(style: .utility, size: .small, withAutoLayout: true)
        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        button.addTarget(self, action: #selector(addToCalendarButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var separator: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(contentStackView)
        addSubview(separator)
        contentStackView.fillInSuperview()

        backgroundColor = .bgPrimary

        dateStackView.addArrangedSubviews([monthLabel, dayLabel])
        weekdayTimeStackView.addArrangedSubviews([weekdayLabel, timeLabel])
        viewingStackView.addArrangedSubviews([dateStackView, weekdayTimeStackView, addToCalendarButton])
        contentStackView.addArrangedSubviews([viewingStackView, noteLabel])

        NSLayoutConstraint.activate([
            viewingStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: Self.viewingStackViewHeight),
            viewingStackView.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            dateStackView.widthAnchor.constraint(equalToConstant: Self.dateViewWidth),
            noteLabel.leadingAnchor.constraint(equalTo: dateStackView.trailingAnchor, constant: .spacingS),

            separator.leadingAnchor.constraint(equalTo: weekdayTimeStackView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }

    // MARK: - Internal methods

    func configure(
        with viewModel: ViewingItemViewModel,
        addToCalendarButtonTitle: String,
        showSeparator: Bool,
        topEdgeInset: CGFloat = 0
    ) {
        separator.alpha = showSeparator ? 1 : 0

        weekdayLabel.text = viewModel.weekday
        monthLabel.text = viewModel.month
        dayLabel.text = viewModel.day
        addToCalendarButton.setTitle(addToCalendarButtonTitle, for: .normal)
        
        if let timeInterval = viewModel.timeInterval {
            timeLabel.text = timeInterval
            timeLabel.isHidden = false
        } else {
            timeLabel.isHidden = true
        }
        
        var bottomMargin: CGFloat = 0
        if let note = viewModel.note {
            noteLabel.text = note
            noteLabel.isHidden = false
            bottomMargin = noteBottomMargin
        } else {
            noteLabel.isHidden = true
        }
        
        contentStackView.layoutMargins = UIEdgeInsets(top: topEdgeInset, bottom: bottomMargin)
    }

    // MARK: - Actions

    @objc func addToCalendarButtonTapped() {
        delegate?.viewingItemViewDidSelectAddToCalendarButton(self)
    }
}
