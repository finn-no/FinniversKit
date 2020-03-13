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
        let stackView = UIStackView(arrangedSubviews: [pricesStackView, linkButtonListView])
        stackView.axis = .vertical
        stackView.spacing = .spacingM
        return stackView
    }()

    private lazy var linkButtonListView: LinkButtonListView = {
        let view = LinkButtonListView(withAutoLayout: true)
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
        addSubview(wrapperStackView)
        wrapperStackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModel: ObjectPagePriceViewModel) {


        linkButtonListView.configure(with: viewModel.links)
        linkButtonListView.isHidden = viewModel.links.isEmpty
    }
}

// MARK: - LinkButtonListViewDelegate

extension ObjectPagePriceView: LinkButtonListViewDelegate {
    public func linksListView(_ view: LinkButtonListView, didTapButtonWithIdentifier identifier: String?, url: URL) {
        delegate?.priceView(self, didTapLinkButtonWithIdentifier: identifier, url: url)
    }
}

// MARK: - Private class

private class PriceView: UIView {

    // MARK: - Private properties

    private let viewModel: ObjectPagePriceViewModel.Price
    private lazy var titleLabel = Label(style: .body, withAutoLayout: true)
    private lazy var totalPriceLabel = Label(style: .title3Strong, withAutoLayout: true)
    private lazy var subtitleLabel = Label(style: .caption, withAutoLayout: true)

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, totalPriceLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Init

    init(viewModel: ObjectPagePriceViewModel.Price, withAutoLayout: Bool) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        titleLabel.text = viewModel.title
        totalPriceLabel.text = viewModel.totalPrice

        subtitleLabel.text = viewModel.subtitle
        subtitleLabel.isHidden = viewModel.subtitle?.isEmpty ?? true

        addSubview(textStackView)
        textStackView.fillInSuperview()
    }
}
