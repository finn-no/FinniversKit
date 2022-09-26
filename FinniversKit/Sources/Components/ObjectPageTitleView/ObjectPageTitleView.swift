//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class ObjectPageTitleView: UIView {

    // MARK: - Public properties

    public var isTitleTextCopyable: Bool {
        get { titleLabel.isTextCopyable }
        set { titleLabel.setTextCopyable(newValue) }
    }

    public var isSubtitleTextCopyable: Bool {
        get { subtitleLabel.isTextCopyable }
        set { subtitleLabel.setTextCopyable(newValue) }
    }

    // MARK: - Private properties

    private let titleStyle: Label.Style
    private let subtitleStyle: Label.Style
    private let captionStyle: Label.Style
    private lazy var ribbonView = RibbonView(withAutoLayout: true)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ribbonView, titleLabel, subtitleLabel, captionLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.setCustomSpacing(.spacingS, after: ribbonView)
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

    private lazy var captionLabel: Label = {
        let label = Label(style: captionStyle, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    public init(titleStyle: Label.Style = .title2, subtitleStyle: Label.Style = .body, captionStyle: Label.Style = .caption, withAutoLayout: Bool = false) {
        self.titleStyle = titleStyle
        self.subtitleStyle = subtitleStyle
        self.captionStyle = captionStyle
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout

        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
        setupAccessibility()
    }

    private func setupAccessibility() {
        isAccessibilityElement = false
        let accessibilityElements = [titleLabel, subtitleLabel, captionLabel, ribbonView]

        accessibilityElements.forEach {
            if $0 == titleLabel {
                $0.accessibilityTraits = .header
            } else {
                $0.accessibilityTraits = .staticText
            }
        }

        self.accessibilityElements = accessibilityElements
    }

    // MARK: - Public methods

    public func configure(
        withTitle title: String? = nil,
        subtitle: String? = nil,
        caption: String? = nil,
        ribbonViewModel: RibbonViewModel? = nil,
        spacingAfterTitle: CGFloat = .spacingXS,
        spacingAfterSubtitle: CGFloat = .spacingXS
    ) {
        titleLabel.text = title
        titleLabel.isHidden = title?.isEmpty ?? true

        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle?.isEmpty ?? true

        captionLabel.text = caption
        captionLabel.isHidden = caption?.isEmpty ?? true

        if let ribbonViewModel = ribbonViewModel {
            ribbonView.configure(with: ribbonViewModel)
        }
        ribbonView.isHidden = ribbonViewModel == nil

        stackView.setCustomSpacing(spacingAfterTitle, after: titleLabel)
        stackView.setCustomSpacing(spacingAfterSubtitle, after: subtitleLabel)
    }
}
