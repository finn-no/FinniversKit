//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

public protocol SaveSearchViewDelegate: AnyObject {
    func saveSearchView(_ saveSearchView: SaveSearchView, didUpdateIsNotificationCenterOn: Bool)
    func saveSearchView(_ saveSearchView: SaveSearchView, didUpdateIsPushOn: Bool)
    func saveSearchView(_ saveSearchView: SaveSearchView, didUpdateIsEmailOn: Bool)
    func saveSearchViewDidSelectEditSearchNameButton(_ saveSearchView: SaveSearchView)
    func saveSearchViewDidSelectDeleteSearchButton(_ saveSearchView: SaveSearchView)
}

public class SaveSearchView: UIView {

    // MARK: - Public properties

    public weak var delegate: SaveSearchViewDelegate?
    public var isNotificationCenterOn: Bool { notificationCenterSwitchView.isOn }
    public var isPushOn: Bool { pushSwitchView.isOn }
    public var isEmailOn: Bool { emailSwitchView.isOn }

    // MARK: - Private properties

    private lazy var contentView = UIView(withAutoLayout: true)
    private lazy var notificationCenterSwitchView = createSwitchView()
    private lazy var pushSwitchView = createSwitchView()
    private lazy var emailSwitchView = createSwitchView()
    private var heightConstraint: NSLayoutConstraint!

    private let switchStyle = SwitchViewStyle(
        titleLabelStyle: .bodyStrong,
        titleLabelTextColor: .textPrimary,
        detailLabelStyle: .caption,
        detailLabelTextColor: .textPrimary
    )

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .emptySavedSearchNotificationsIcon)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var searchNameLabel: Label = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var editSearchNameButton: Button = {
        let button = Button(style: .flat, size: .small, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleEditSearchNameButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.contentInsetAdjustmentBehavior = .always
        return scrollView
    }()

    private lazy var deleteSavedSearchButton: Button = {
        let button = Button(style: .destructive, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleDeleteButtonTap), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public methods

    public func configure(with viewModel: SaveSearchViewModel) {
        searchNameLabel.text = viewModel.searchTitle
        editSearchNameButton.setTitle(viewModel.editNameButtonTitle, for: .normal)

        notificationCenterSwitchView.configure(with: viewModel.notificationCenterSwitchViewModel)
        pushSwitchView.configure(with: viewModel.pushSwitchViewModel)
        emailSwitchView.configure(with: viewModel.emailSwitchViewModel)

        if let deleteSearchButtonTitle = viewModel.deleteSearchButtonTitle {
            deleteSavedSearchButton.isHidden = false
            deleteSavedSearchButton.setTitle(deleteSearchButtonTitle, for: .normal)
        } else {
            deleteSavedSearchButton.isHidden = true
        }
    }

    public func configure(searchName: String?) {
        searchNameLabel.text = searchName
    }

    public func setNotificationCenterOn(_ isOn: Bool, animated: Bool) {
        notificationCenterSwitchView.setOn(isOn, animated: animated)
        delegate?.saveSearchView(self, didUpdateIsNotificationCenterOn: isOn)
    }

    public func setPushOn(_ isOn: Bool, animated: Bool) {
        pushSwitchView.setOn(isOn, animated: animated)
        delegate?.saveSearchView(self, didUpdateIsPushOn: isOn)
    }

    public func setEmailOn(_ isOn: Bool, animated: Bool) {
        emailSwitchView.setOn(isOn, animated: animated)
        delegate?.saveSearchView(self, didUpdateIsEmailOn: isOn)
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .bgPrimary

        scrollView.addSubview(contentView)
        addSubview(scrollView)
        scrollView.fillInSuperview()

        contentView.addSubview(iconImageView)
        contentView.addSubview(searchNameLabel)
        contentView.addSubview(editSearchNameButton)
        contentView.addSubview(stackView)
        contentView.addSubview(deleteSavedSearchButton)

        stackView.addArrangedSubviews([
            notificationCenterSwitchView,
            HairlineView(),
            pushSwitchView,
            HairlineView(),
            emailSwitchView
        ])

        stackView.arrangedSubviews.filter { $0 is HairlineView }.forEach {
            $0.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        }

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: widthAnchor),

            iconImageView.heightAnchor.constraint(equalToConstant: 48),
            iconImageView.widthAnchor.constraint(equalToConstant: 48),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingM),

            searchNameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .spacingM),
            searchNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            searchNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),

            editSearchNameButton.topAnchor.constraint(equalTo: searchNameLabel.bottomAnchor, constant: .spacingXS),
            editSearchNameButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            editSearchNameButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),

            stackView.topAnchor.constraint(equalTo: editSearchNameButton.bottomAnchor, constant: .spacingM),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            deleteSavedSearchButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .spacingL + .spacingM),
            deleteSavedSearchButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingM),
            deleteSavedSearchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingM),
            deleteSavedSearchButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func createSwitchView() -> SwitchView {
        let view = SwitchView(style: switchStyle, withAutoLayout: true)
        view.delegate = self
        return view
    }

    // MARK: - Actions

    @objc private func handleDeleteButtonTap() {
        delegate?.saveSearchViewDidSelectDeleteSearchButton(self)
    }

    @objc private func handleEditSearchNameButtonTap() {
        delegate?.saveSearchViewDidSelectEditSearchNameButton(self)
    }
}

// MARK: - SwitchViewDelegate

extension SaveSearchView: SwitchViewDelegate {
    public func switchView(_ switchView: SwitchView, didChangeValueFor switch: UISwitch) {
        switch switchView {
        case notificationCenterSwitchView:
            delegate?.saveSearchView(self, didUpdateIsNotificationCenterOn: switchView.isOn)
        case pushSwitchView:
            delegate?.saveSearchView(self, didUpdateIsPushOn: switchView.isOn)
        case emailSwitchView:
            delegate?.saveSearchView(self, didUpdateIsEmailOn: switchView.isOn)
        default:
            break
        }
    }
}

// MARK: - Private types

private class HairlineView: UIView {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let line = UIView(withAutoLayout: true)
        line.backgroundColor = .textDisabled
        addSubview(line)
        line.fillInSuperview(insets: UIEdgeInsets(leading: .spacingM))
    }
}
