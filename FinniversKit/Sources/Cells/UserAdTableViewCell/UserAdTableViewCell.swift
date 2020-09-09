//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation
import UIKit

public protocol ImageLoading {
    func loadImage()
}

public class UserAdTableViewCell: UITableViewCell {

    public enum Style {
        case `default`
        case compressed

        var imageSize: CGFloat {
            switch self {
            case .default: return 80
            case .compressed: return 50
            }
        }
    }

    // MARK: - Public properties

    public var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            userAdDetailsView.adImageViewDataSource = remoteImageViewDataSource
        }
    }

    public var loadingColor: UIColor? {
        didSet {
            userAdDetailsView.loadingColor = loadingColor
        }
    }

    // MARK: - Private properties

    private lazy var userAdDetailsView: UserAdDetailsView = {
        let view = UserAdDetailsView(withAutoLayout: true)
        view.directionalLayoutMargins = .zero
        return view
    }()

    private lazy var userAdDetailsViewTopAnchor = userAdDetailsView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor)
    private lazy var userAdDetailsViewBottomAnchor = userAdDetailsView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: 0, priority: .init(999))

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .bgPrimary
        selectionStyle = .none

        contentView.addSubview(userAdDetailsView)

        NSLayoutConstraint.activate([
            userAdDetailsView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            userAdDetailsView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            userAdDetailsViewTopAnchor,
            userAdDetailsViewBottomAnchor,
        ])
    }

    // MARK: Public methods

    public func configure(with style: Style, model: UserAdTableViewCellViewModel) {
        separatorInset = .leadingInset(.spacingXL + style.imageSize)
        accessibilityLabel = model.accessibilityLabel

        userAdDetailsView.configure(with: style, model: model)
    }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        accessoryType = .none
        userAdDetailsView.resetContent()
    }
}

// MARK: - ImageLoading

extension UserAdTableViewCell: ImageLoading {
    public func loadImage() {
        userAdDetailsView.loadImage()
    }
}
