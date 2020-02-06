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

    private lazy var titleLabel = Label(style: .body, withAutoLayout: true)
    private lazy var totalPriceLabel = Label(style: .title3Strong, withAutoLayout: true)

    private lazy var wrapperStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [textStackView, linkStackView])
        stackView.axis = .vertical
        stackView.spacing = .mediumSpacing
        return stackView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, totalPriceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var linkStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        return stackView
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
        titleLabel.text = viewModel.title
        totalPriceLabel.text = viewModel.totalPrice

        linkStackView.removeArrangedSubviews()

        viewModel.links.map(LinkButtonView.init).forEach {
            $0.delegate = self
            $0.setContentHuggingPriority(.required, for: .horizontal)
            linkStackView.addArrangedSubview($0)
        }
        linkStackView.isHidden = viewModel.links.isEmpty
    }
}

// MARK: - LinkButtonViewDelegate

extension ObjectPagePriceView: LinkButtonViewDelegate {
    func linkButton(withIdentifier identifier: String?, wasTappedWithUrl url: URL) {
        delegate?.priceView(self, didTapLinkButtonWithIdentifier: identifier, url: url)
    }
}
