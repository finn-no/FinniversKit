//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public protocol ObjectPagePriceViewDelegate: AnyObject {
    func priceView(_ view: ObjectPagePriceView, didTapLinkButtonWithIdentifier identifier: String?, url: URL)
}

public class ObjectPagePriceView: UIView {

    // MARK: - Public properties

    public weak var delegate: ObjectPagePriceViewDelegate?

    // MARK: - Private properties

    private lazy var pricesStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var wrapperStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .spacingM
        return stackView
    }()

    private lazy var linkButtonListView: PriceLinkButtonListView = {
        let view = PriceLinkButtonListView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var priceDetailsView: KeyValueGridView = {
        let view = KeyValueGridView(withAutoLayout: true)
        return view
    }()

    private lazy var captionLabel = Label(style: .caption, withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(wrapperStackView)
        wrapperStackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModel: ObjectPagePriceViewModel, style: Style = .init()) {
        wrapperStackView.removeArrangedSubviews()
        pricesStackView.removeArrangedSubviews()

        if let adTypeText = viewModel.adTypeText {
            let adTypeLabel = Label(style: style.adTypeStyle, withAutoLayout: true)
            adTypeLabel.text = adTypeText
            wrapperStackView.addArrangedSubview(adTypeLabel)
            wrapperStackView.setCustomSpacing(.spacingXS, after: adTypeLabel)
        }

        if let mainPriceModel = viewModel.mainPriceModel {
            let mainPriceView = PriceView(viewModel: mainPriceModel, style: style, withAutoLayout: true)
            pricesStackView.addArrangedSubview(mainPriceView)
        }

        if let secondaryPriceModel = viewModel.secondaryPriceModel {
            let secondaryPriceView = PriceView(viewModel: secondaryPriceModel, style: style, withAutoLayout: true)
            pricesStackView.addArrangedSubview(secondaryPriceView)
        }

        wrapperStackView.addArrangedSubview(pricesStackView)

        if let captionText = viewModel.captionText {
            captionLabel.attributedText = captionText
            wrapperStackView.addArrangedSubview(captionLabel)
        }

        if !viewModel.priceDetails.isEmpty {
            priceDetailsView.configure(with: viewModel.priceDetails)
            wrapperStackView.addArrangedSubview(priceDetailsView)
            priceDetailsView.numberOfColumns = viewModel.priceDetailsNumberOfColumns
        }

        wrapperStackView.addArrangedSubview(linkButtonListView)

        linkButtonListView.configure(with: viewModel.links)
        linkButtonListView.isHidden = viewModel.links.isEmpty

        pricesStackView.isHidden = pricesStackView.arrangedSubviews.isEmpty
    }

    public func showCaptionLabel(_ text: NSAttributedString) {
        if wrapperStackView.subviews.contains(captionLabel) {
            captionLabel.attributedText = text
        } else {
            captionLabel.attributedText = text
            wrapperStackView.addArrangedSubview(captionLabel)
        }
    }
}

// MARK: - PriceLinkButtonListViewDelegate

extension ObjectPagePriceView: PriceLinkButtonListViewDelegate {
    public func priceLinksListView(_ view: PriceLinkButtonListView, didTapButtonWithIdentifier identifier: String?, url: URL) {
        delegate?.priceView(self, didTapLinkButtonWithIdentifier: identifier, url: url)
    }
}

// MARK: - Private class

private class PriceView: UIView {

    // MARK: - Private properties

    private let viewModel: ObjectPagePriceViewModel.Price
    private let style: ObjectPagePriceView.Style
    private lazy var titleLabel = Label(style: style.titleStyle, withAutoLayout: true)
    private lazy var totalPriceLabel = Label(style: style.priceStyle, withAutoLayout: true)
    private lazy var subtitleLabel = Label(style: style.subtitleStyle, withAutoLayout: true)

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, totalPriceLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Init

    init(viewModel: ObjectPagePriceViewModel.Price, style: ObjectPagePriceView.Style, withAutoLayout: Bool) {
        self.viewModel = viewModel
        self.style = style
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        isAccessibilityElement = true
        accessibilityTraits = .staticText
        if let accessibilityLabel = viewModel.accessibilityLabel {
            self.accessibilityLabel = accessibilityLabel
        } else {
            var accessibilityLabel = viewModel.totalPrice

            if let title = viewModel.title {
                accessibilityLabel = "\(title): \(accessibilityLabel)"
            }

            if let subtitle = viewModel.subtitle {
                accessibilityLabel = "\(accessibilityLabel). \(subtitle)"
            }
            self.accessibilityLabel = accessibilityLabel
        }

        titleLabel.text = viewModel.title
        titleLabel.isHidden = viewModel.title?.isEmpty ?? true

        totalPriceLabel.text = viewModel.totalPrice

        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle?.isEmpty ?? true

        addSubview(textStackView)
        textStackView.fillInSuperview()
    }
}

public extension ObjectPagePriceView {
    struct Style {
        let titleStyle: Label.Style
        let priceStyle: Label.Style
        let subtitleStyle: Label.Style
        let adTypeStyle: Label.Style

        public init(
            titleStyle: Label.Style = .body,
            priceStyle: Label.Style = .title3Strong,
            subtitleStyle: Label.Style = .caption,
            adTypeStyle: Label.Style = .bodyStrong
        ) {
            self.titleStyle = titleStyle
            self.priceStyle = priceStyle
            self.subtitleStyle = subtitleStyle
            self.adTypeStyle = adTypeStyle
        }
    }
}
