import UIKit

@objc protocol SavedSearchesListViewCellDelegate: class {
    func savedSearchesListViewCell(_ savedSearchesListViewCell: SavedSearchesListViewCell, didPressSettingsForItemAt indexPath: IndexPath?)
}

@objc class SavedSearchesListViewCell: UITableViewCell {
    @objc weak var delegate: SavedSearchesListViewCellDelegate?
    @objc var indexPath: IndexPath?

    @objc lazy var titleLabel: UILabel = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    @objc lazy var subtitleLabel: UILabel = {
        let label = Label(style: .detail)
        label.textColor = .primaryBlue
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    @objc lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.addArrangedSubview(self.titleLabel)
        view.addArrangedSubview(self.subtitleLabel)

        return view
    }()

    @objc lazy var settingsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: FinniversImageAsset.settings), for: .normal)
        button.addTarget(self, action: #selector(showSettings(button:)), for: .touchUpInside)
        button.isAccessibilityElement = true

        return button
    }()

    @objc lazy var arrowImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .center
        view.image = UIImage(named: FinniversImageAsset.arrowRight)

        return view
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(stackView)
        contentView.addSubview(settingsButton)
        contentView.addSubview(arrowImageView)

        let margin: CGFloat = .mediumSpacing
        let settingsSize: CGFloat = 50
        let arrowSize: CGFloat = 20
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin * 2),
            stackView.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -margin * 2),

            settingsButton.widthAnchor.constraint(equalToConstant: settingsSize),
            settingsButton.heightAnchor.constraint(equalToConstant: settingsSize),
            settingsButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor),

            arrowImageView.widthAnchor.constraint(equalToConstant: arrowSize),
            arrowImageView.heightAnchor.constraint(equalToConstant: arrowSize),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            // We use "greaterThanOrEqualTo" instead of "equalTo" because otherwise we get an AutoLayout error
            arrowImageView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -margin * 2)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func showSettings(button: UIButton) {
        if let indexPath = indexPath {
            delegate?.savedSearchesListViewCell(self, didPressSettingsForItemAt: indexPath)
        }
    }

    // MARK: - Dependency injection

    public func update(model: SavedSearchesListViewModel?, indexPath: IndexPath?) {
        titleLabel.text = model?.title
        subtitleLabel.text = model?.subtitle
        accessibilityLabel = model?.accessibilityLabel
        settingsButton.accessibilityLabel = model?.settingsButtonAccessibilityLabel
        self.indexPath = indexPath
    }
}
