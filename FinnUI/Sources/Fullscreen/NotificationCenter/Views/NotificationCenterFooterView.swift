//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//
import FinniversKit

protocol NotificationCenterFooterViewDelegate: AnyObject {
    func notificationCenterSectionFooterView(
        _ footerView: NotificationCenterFooterView,
        didSelectButtonIn section: Int
    )
}

class NotificationCenterFooterView: UITableViewHeaderFooterView {

    // MARK: - Internal properties

    weak var delegate: NotificationCenterFooterViewDelegate?

    // MARK: - Priate properties

    private lazy var button: Button = {
        let button = Button(style: .default, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonSelected), for: .touchUpInside)
        return button
    }()

    private var section: Int?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingM)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil, inSection: nil)
    }

    func configure(with text: String?, inSection section: Int?) {
        self.section = section
        button.setTitle(text, for: .normal)
    }

    @objc func handleButtonSelected() {
        guard let section = section else { return }
        delegate?.notificationCenterSectionFooterView(self, didSelectButtonIn: section)
    }
}
