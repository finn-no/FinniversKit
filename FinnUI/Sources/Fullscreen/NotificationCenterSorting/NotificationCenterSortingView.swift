//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public struct SortOptionCellViewModel {
    let title: String
    let icon: UIImage
    
    public init(title: String, icon: UIImage) {
        self.title = title
        self.icon = icon
    }
}

public protocol SortingOptionsViewDataSource: AnyObject {
    func sortingOptionsView<SortOption>(_ view: SortingOptionsView<SortOption>, cellConfigurationFor option: SortOption) -> SortOptionCellViewModel
}

public protocol SortingOptionsViewDelegate: AnyObject {
    func sortingOptionsView<SortOption>(_ view: SortingOptionsView<SortOption>, didSelectSortOption option: SortOption)
}

public class SortingOptionsView<SortOption>: UIView, UITableViewDataSource, UITableViewDelegate where SortOption: CaseIterable & Equatable {
    // MARK: - Public properties

    public weak var dataSource: SortingOptionsViewDataSource?
    public weak var delegate: SortingOptionsViewDelegate?

    // MARK: - Private properties

    private let options = Array(SortOption.allCases)
    private var selectedSortOption: SortOption?

    private lazy var tableView: UITableView = {
        let rowHeight: CGFloat = 48.0
        
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .bgPrimary
        tableView.rowHeight = rowHeight
        tableView.estimatedRowHeight = rowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
        tableView.register(SortOptionCell.self)
        return tableView
    }()
    
    private let cellConfiguration: ((SortOption) -> SortOptionCellViewModel)?

    // MARK: - Init
    
    public init(selectedSortOption: SortOption?, cellConfiguration: ((SortOption) -> SortOptionCellViewModel)? = nil) {
        self.selectedSortOption = selectedSortOption
        self.cellConfiguration = cellConfiguration
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    // MARK: - UITableViewDataSource

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let cell = tableView.dequeue(SortOptionCell.self, for: indexPath)
        
        if let cellViewModel = cellConfiguration?(option) {
            cell.configure(withTitle: cellViewModel.title, image: cellViewModel.icon)
        }

        cell.isCheckmarkHidden = option != selectedSortOption

        return cell
    }

    // MARK: - UITableViewDelegate

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[indexPath.row]
        selectedSortOption = option

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        delegate?.sortingOptionsView(self, didSelectSortOption: option)
    }
}

final class SortOptionCell: UITableViewCell {
    static let iconSize: CGFloat = 24

    var isCheckmarkHidden = true {
        didSet {
            hideCheckmark(isCheckmarkHidden)
        }
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel = UILabel(withAutoLayout: true)

    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView.checkmarkImageView
        imageView.isHidden = true
        return imageView
    }()

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Overrides

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkmarkImageView.backgroundColor = .btnPrimary
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        checkmarkImageView.backgroundColor = .btnPrimary
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hideCheckmark(true)
    }

    // MARK: - Public

    func configure(withTitle title: String, image: UIImage) {
        titleLabel.text = title
        iconImageView.image = image.withRenderingMode(.alwaysTemplate)
    }

    // MARK: - Private methods

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .bgPrimary
        setDefaultSelectedBackgound()
        hideCheckmark(true)

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            iconImageView.widthAnchor.constraint(equalToConstant: SortOptionCell.iconSize),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -.spacingS),

            checkmarkImageView.heightAnchor.constraint(equalToConstant: .spacingM),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: .spacingM),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    private func hideCheckmark(_ hide: Bool) {
        iconImageView.tintColor = hide ? .iconPrimary : .btnPrimary

        titleLabel.font = hide ? .body : .bodyStrong
        titleLabel.textColor = iconImageView.tintColor

        checkmarkImageView.isHidden = hide
    }
}
