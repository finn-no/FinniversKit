//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ViewingsViewDelegate: AnyObject {
    func viewingsViewDidSelectAddToCalendarButton(_ view: ViewingsView, forIndex index: Int)
}

public class ViewingsView: UIView {
    public weak var delegate: ViewingsViewDelegate?

    // MARK: - Private properties

    private var viewModel: ViewingsViewModel?

    private let titleHeight: CGFloat = 27
    private var contentMargin: CGFloat = .mediumSpacing
    private let noteTopMargin: CGFloat = .mediumSpacing

    private lazy var titleLabel: Label = Label(style: .title3, withAutoLayout: true)

    private lazy var noteLabel: Label = {
        let label = Label(withAutoLayout: true)
        label.isHidden = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ViewingCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.rowHeight = ViewingCell.cellHeight
        tableView.estimatedRowHeight = ViewingCell.cellHeight
        tableView.isScrollEnabled = false
        tableView.separatorColor = .tableViewSeparator
        tableView.separatorInset = UIEdgeInsets(top: 0, left: ViewingCell.dateViewWidth + ViewingCell.contentSpacing, bottom: 0, right: 0)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        tableView.tableFooterView?.backgroundColor = .bgPrimary
        return tableView
    }()

    // MARK: - Init

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        if UIDevice.isIPad() {
            contentMargin = 0
        }

        addSubview(titleLabel)
        addSubview(noteLabel)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            noteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: noteTopMargin),
            noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: contentMargin),
            noteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentMargin),

            tableView.topAnchor.constraint(equalTo: noteLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: ViewingsViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.title
        if let note = viewModel.note {
            noteLabel.attributedText = attributedNoteString(with: note)
            noteLabel.isHidden = false
        }
        tableView.reloadData()
    }

    public func heightNeeded(forWidth width: CGFloat) -> CGFloat {
        let noteHeight = noteLabel.sizeThatFits(CGSize(width: width - 2 * contentMargin, height: CGFloat.greatestFiniteMagnitude)).height
        let cellsHeight: CGFloat = ViewingCell.cellHeight * CGFloat(viewModel?.viewings.count ?? 0)
        return titleHeight + noteTopMargin + noteHeight + cellsHeight
    }

    // MARK: - Private methods

    private func attributedNoteString(with text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = .verySmallSpacing

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.body
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
}

// MARK: - UITableViewDataSource

extension ViewingsView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.viewings.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ViewingCell.self, for: indexPath)
        guard let viewModel = viewModel else { return cell }
        cell.configure(with: viewModel.viewings[indexPath.row], addToCalendarButtonTitle: viewModel.addToCalendarButtonTitle)

        cell.selectionStyle = .none
        cell.contentView.isUserInteractionEnabled = false

        cell.delegate = self
        return cell
    }
}

// MARK: - ViewingCellDelegate

extension ViewingsView: ViewingCellDelegate {
    func viewingCellDidSelectAddToCalendarButton(_ cell: ViewingCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        delegate?.viewingsViewDidSelectAddToCalendarButton(self, forIndex: indexPath.row)
    }
}
