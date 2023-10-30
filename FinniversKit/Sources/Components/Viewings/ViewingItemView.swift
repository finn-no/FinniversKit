import UIKit

protocol ViewingItemViewDelegate: AnyObject {
    func viewingItemViewDidSelectAddToCalendarButton(_ view: ViewingItemView)
}

class ViewingItemView: UIView {
    enum Layout {
        case original
        case redesign
    }

    // MARK: - Internal properties

    weak var delegate: ViewingItemViewDelegate?

    // MARK: - Private properties

    private let layout: Layout
    private let noteBottomMargin: CGFloat = .spacingM
    private lazy var dayLabel = Label(style: .title3, withAutoLayout: true)
    private lazy var weekdayLabel = Label(style: .body, withAutoLayout: true)
    private lazy var monthLabel = Label(style: .detail, textColor: .textNegative, withAutoLayout: true)
    private lazy var noteLabel = Label(style: .detail, numberOfLines: 0, textColor: .textSubtle, withAutoLayout: true)
    private lazy var viewingStackView = UIStackView(axis: .horizontal, spacing: .spacingS, alignment: .center, withAutoLayout: true)
    private lazy var dateStackView = UIStackView(axis: .vertical, withAutoLayout: true)
    private lazy var weekdayTimeStackView = UIStackView(axis: .vertical, spacing: .spacingXXS, alignment: .leading, withAutoLayout: true)
    private lazy var contentStackViewLeadingConstraint = contentStackView.leadingAnchor.constraint(equalTo: dateStackView.trailingAnchor)

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(axis: .vertical, withAutoLayout: true)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var timeLabel: Label = {
        let label = Label(style: .detail, textColor: .textSubtle, withAutoLayout: true)
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
        view.backgroundColor = .border
        return view
    }()

    // MARK: - Init

    init(layout: Layout, withAutoLayout: Bool) {
        self.layout = layout
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .background

        dateStackView.addArrangedSubviews([monthLabel, dayLabel])
        weekdayTimeStackView.addArrangedSubviews([weekdayLabel, timeLabel])
        viewingStackView.addArrangedSubviews([weekdayTimeStackView, addToCalendarButton])
        contentStackView.addArrangedSubviews([viewingStackView, noteLabel])

        addSubview(dateStackView)
        addSubview(contentStackView)
        addSubview(separator)

        NSLayoutConstraint.activate([
            viewingStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            viewingStackView.centerYAnchor.constraint(equalTo: dateStackView.centerYAnchor),

            dateStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            dateStackView.leadingAnchor.constraint(equalTo: leadingAnchor),

            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackViewLeadingConstraint,
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            separator.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])

        switch layout {
        case .original:
            dateStackView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            dateStackView.alignment = .center
            contentStackViewLeadingConstraint.constant = .spacingS
        case .redesign:
            dateStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 28).isActive = true
            contentStackViewLeadingConstraint.constant = .spacingM
            dateStackView.setContentHuggingPriority(.required, for: .horizontal)
            dateStackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        }
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

        timeLabel.text = viewModel.timeInterval
        timeLabel.isHidden = viewModel.timeInterval == nil
        
        var bottomMargin: CGFloat = 0
        if let note = viewModel.note {
            noteLabel.text = note
            bottomMargin = noteBottomMargin
        }
        noteLabel.isHidden = viewModel.note == nil

        contentStackView.layoutMargins = UIEdgeInsets(top: topEdgeInset, bottom: bottomMargin)
    }

    // MARK: - Actions

    @objc func addToCalendarButtonTapped() {
        delegate?.viewingItemViewDidSelectAddToCalendarButton(self)
    }
}
