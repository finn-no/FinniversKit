//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class ObjectPageTitleView: UIView {

    // MARK: - Private properties

    private let titleStyle: Label.Style
    private let subtitleStyle: Label.Style
    private lazy var ribbonView = RibbonView(withAutoLayout: true)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ribbonView, titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.setCustomSpacing(.mediumSpacing, after: ribbonView)
        return stackView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: titleStyle, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: subtitleStyle, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    public init(titleStyle: Label.Style = .title2, subtitleStyle: Label.Style = .body, withAutoLayout: Bool = false) {
        self.titleStyle = titleStyle
        self.subtitleStyle = subtitleStyle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(withTitle title: String? = nil, subtitle: String? = nil, ribbonViewModel: RibbonViewModel? = nil) {
        if let ribbonViewModel = ribbonViewModel {
            ribbonView.configure(with: ribbonViewModel)
        }
        ribbonView.isHidden = ribbonViewModel == nil

        titleLabel.text = title
        titleLabel.isHidden = title?.isEmpty ?? true

        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle?.isEmpty ?? true
    }
}
