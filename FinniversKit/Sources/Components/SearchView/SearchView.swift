import UIKit

public protocol SearchViewDelegate: AnyObject {
    func searchView(_ view: SearchView, didSelectItemAtIndex index: Int)
    func searchView(_ view: SearchView, didChangeSearchText searchText: String?)
}

public class SearchView: UIView {

    // MARK: - Public properties

    public weak var delegate: SearchViewDelegate?

    public var searchText: String? {
        searchTextField.text
    }

    // MARK: - Private properties

    private var items = [String]()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .bgPrimary
        tableView.keyboardDismissMode = .onDrag
        tableView.register(ResultTableViewCell.self)
        return tableView
    }()

    private lazy var searchTextField: TextField = {
        let view = TextField(inputType: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textField.returnKeyType = .search
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary
        addSubview(searchTextField)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            searchTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Public methods

    public func configure(items: [String]) {
        self.items = items
        tableView.reloadData()
    }

    public func configureSearchTextField(placeholder: String, text: String?) {
        searchTextField.textField.placeholder = placeholder
        searchTextField.textField.text = text
    }

    // MARK: - Overrides

    public override var canBecomeFirstResponder: Bool {
        true
    }

    public override func becomeFirstResponder() -> Bool {
        searchTextField.becomeFirstResponder()
    }
}

// MARK: - UITableViewDelegate

extension SearchView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchView(self, didSelectItemAtIndex: indexPath.row)
    }
}

// MARK: - UITableViewDataSource

extension SearchView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(ResultTableViewCell.self, for: indexPath)
        cell.configure(with: items[indexPath.row])
        return cell
    }
}

// MARK: - TextFieldDelegate

extension SearchView: TextFieldDelegate {
    public func textFieldDidChange(_ textField: TextField) {
        delegate?.searchView(self, didChangeSearchText: textField.text)
    }
}

// MARK: - Private types

private class ResultTableViewCell: UITableViewCell {

    // MARK: - Private properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contentView.addSubview(titleLabel)
        titleLabel.fillInSuperview(margin: .spacingM)
    }

    // MARK: - Internal methods

    func configure(with title: String) {
        titleLabel.text = title
    }

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}
