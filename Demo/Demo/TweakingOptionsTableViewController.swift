import UIKit
import FinniversKit

protocol Tweakable {
    var tweakingOptions: [TweakingOption] { get set }
}

struct TweakingOption {
    var title: String
    var description: String?
    var action: ((_ parentViewController: UIViewController?) -> Void)
}

class TweakingOptionsTableViewController: UIViewController {
    let options: [TweakingOption]

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()

    init(options: [TweakingOption]) {
        self.options = options
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        view.addSubview(tableView)
        tableView.fillInSuperview()
        tableView.register(OptionCell.self)
    }
}

// MARK: - UITableViewDataSource

extension TweakingOptionsTableViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(OptionCell.self, for: indexPath)
        let option = options[indexPath.row]
        cell.option = option
        return cell
    }
}

// MARK: - UITableViewDelegate

extension TweakingOptionsTableViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = options[indexPath.row]
        option.action(parent)
    }
}

// MARK: - OptionCell

private class OptionCell: UITableViewCell {

    var option: TweakingOption? {
        didSet {
            titleLabel.text = option?.title
            descriptionLabel.text = option?.description
        }
    }

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumSpacing),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -.mediumSpacing),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing)
            ])
    }
}
