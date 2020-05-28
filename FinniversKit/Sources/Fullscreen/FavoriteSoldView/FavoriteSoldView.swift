//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol FavoriteSoldViewModel {
    var adTitle: String? { get }
    var imageUrl: String? { get }
    var adBody: String { get }
    var ribbonTitle: String { get }
    var similarAdsTitle: String { get }
    var retryButtonTitle: String { get }
    var noRecommendationsTitle: String { get }
}

public protocol FavoriteSoldViewDelegate: AnyObject {
    func favoriteSoldViewDidTapSoldFavorite(_ favoriteSoldView: FavoriteSoldView)
    func favoriteSoldViewDidTapRetryButton(_ favoriteSoldView: FavoriteSoldView)
}

public class FavoriteSoldView: UIView {
    public var model: FavoriteSoldViewModel? {
        didSet {
            if let model = model {
                self.configure(with: model)
            }
        }
    }

    // MARK: - Private properties

    private weak var delegate: FavoriteSoldViewDelegate?

    private static let margins: CGFloat = .spacingM
    private static let titleTopSpacing: CGFloat = .spacingS
    private static let bodyTopSpacing: CGFloat = .spacingXS
    private static let similarAdsTitleTopSpacing: CGFloat = .spacingXL + .spacingS
    private static let adsGridTopSpacing: CGFloat = .spacingM
    private static let imageCornerRadius: CGFloat = 8.0
    private static let imageWidth: CGFloat = 120

    private var didSetupView = false
    private var boundsForCurrentSubviewSetup = CGRect.zero

    // MARK: - Subviews

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(soldFavoriteTapped)))
        return stackView
    }()

    private lazy var imageContentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.layer.cornerRadius = FavoriteSoldView.imageCornerRadius
        view.layer.masksToBounds = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(soldFavoriteTapped)))
        return view
    }()

    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var ribbonView: RibbonView = {
        let view = RibbonView(withAutoLayout: true)
        view.style = .warning
        return view
    }()

    private lazy var titleLabel: Label = {
        let style: Label.Style = traitCollection.horizontalSizeClass == .compact ? .title3Strong : .title2
        let label = Label(style: style, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyLabel: Label = {
        let style: Label.Style = traitCollection.horizontalSizeClass == .compact ? .detail : .body
        let label = Label(style: style, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var similarAdsTitleLabel: Label = {
        let label = Label(style: .title3, withAutoLayout: true)
        return label
    }()

    private let adsGridView: AdsGridView

    private lazy var headerView = UIView()

    private let fallbackImage = UIImage(named: .noImage)

    private lazy var adsRetryView: LoadingRetryView = {
        let view = LoadingRetryView()
        view.delegate = self
        view.state = .hidden
        return view
    }()

    // MARK: - Init

    public convenience init(delegate: FavoriteSoldViewDelegate & AdsGridViewDelegate,
                            adsGridViewDataSource: AdsGridViewDataSource,
                            remoteImageViewDataSource: RemoteImageViewDataSource) {
        self.init(favoriteSoldViewDelegate: delegate,
                  adsGridViewDelegate: delegate,
                  adsGridViewDataSource: adsGridViewDataSource,
                  remoteImageViewDataSource: remoteImageViewDataSource
        )
    }

    init(favoriteSoldViewDelegate: FavoriteSoldViewDelegate,
         adsGridViewDelegate: AdsGridViewDelegate,
         adsGridViewDataSource: AdsGridViewDataSource,
         remoteImageViewDataSource: RemoteImageViewDataSource) {

        adsGridView = AdsGridView(delegate: adsGridViewDelegate, dataSource: adsGridViewDataSource)
        adsGridView.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: .zero)
        delegate = favoriteSoldViewDelegate
        imageView.dataSource = remoteImageViewDataSource
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()

        if didSetupView == false {
            setup()
            didSetupView = true
        } else if !boundsForCurrentSubviewSetup.equalTo(bounds) {
            setupFrames()
        }
    }

    // MARK: - Setup

    private func setup() {
        addSubview(adsGridView)
        adsGridView.collectionView.addSubview(adsRetryView)

        headerView.addSubview(stackView)
        headerView.addSubview(imageContentView)
        headerView.addSubview(similarAdsTitleLabel)

        imageContentView.addSubview(imageView)
        imageView.fillInSuperview()

        stackView.addArrangedSubview(ribbonView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)

        for subview in stackView.arrangedSubviews {
            subview.setContentHuggingPriority(.defaultHigh, for: .vertical)
        }
        let spaceFiller = UIView(withAutoLayout: true)
        spaceFiller.setContentHuggingPriority(.defaultLow, for: .vertical)
        stackView.addArrangedSubview(spaceFiller)

        stackView.setCustomSpacing(FavoriteSoldView.titleTopSpacing, after: ribbonView)
        stackView.setCustomSpacing(FavoriteSoldView.bodyTopSpacing, after: titleLabel)

        NSLayoutConstraint.activate([
            imageContentView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: FavoriteSoldView.margins),
            imageContentView.widthAnchor.constraint(equalToConstant: FavoriteSoldView.imageWidth),
            imageContentView.heightAnchor.constraint(equalTo: imageContentView.widthAnchor),
            imageContentView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: FavoriteSoldView.margins),

            stackView.leadingAnchor.constraint(equalTo: imageContentView.trailingAnchor, constant: FavoriteSoldView.margins),
            stackView.topAnchor.constraint(equalTo: imageContentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -FavoriteSoldView.margins),
            stackView.bottomAnchor.constraint(greaterThanOrEqualTo: imageContentView.bottomAnchor),

            similarAdsTitleLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: FavoriteSoldView.similarAdsTitleTopSpacing),
            similarAdsTitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: FavoriteSoldView.margins),
            similarAdsTitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -FavoriteSoldView.margins),
        ])

        adsGridView.fillInSuperview()
        adsGridView.headerView = headerView
        setupFrames()
    }

    private func setupFrames() {
        let stackViewWidth = frame.size.width - FavoriteSoldView.imageWidth - 3 * FavoriteSoldView.margins

        let ribbonHeight: CGFloat = 19
        let adTitleLabelHeight = titleLabel.sizeThatFits(
            CGSize(width: stackViewWidth, height: CGFloat.greatestFiniteMagnitude)).height
        let adBodyLabelHeight = bodyLabel.sizeThatFits(
            CGSize(width: stackViewWidth, height: CGFloat.greatestFiniteMagnitude)).height
        let similarAdsTitleHeight = similarAdsTitleLabel.intrinsicContentSize.height

        let adInfoHeight = max(FavoriteSoldView.imageWidth, ribbonHeight +
            FavoriteSoldView.titleTopSpacing + adTitleLabelHeight +
            FavoriteSoldView.bodyTopSpacing + adBodyLabelHeight)

        let height = FavoriteSoldView.margins + adInfoHeight +
            FavoriteSoldView.similarAdsTitleTopSpacing + similarAdsTitleHeight +
            FavoriteSoldView.adsGridTopSpacing

        headerView.frame.size.height = height
        boundsForCurrentSubviewSetup = bounds

        adsRetryView.frame.origin = CGPoint(x: 0, y: headerView.frame.height + .spacingXXL)
        adsRetryView.frame.size = CGSize(width: bounds.width, height: 200)

        adsGridView.invalidateLayout()
    }

    // MARK: - Private methods

    private func configure(with model: FavoriteSoldViewModel) {
        titleLabel.text = model.adTitle
        bodyLabel.text = model.adBody
        ribbonView.title = model.ribbonTitle
        similarAdsTitleLabel.text = model.similarAdsTitle
        adsRetryView.set(labelText: model.noRecommendationsTitle, buttonText: model.retryButtonTitle)

        if let imageUrl = model.imageUrl {
            imageView.loadImage(for: imageUrl,
                                imageWidth: FavoriteSoldView.imageWidth,
                                loadingColor: .toothPaste,
                                fallbackImage: fallbackImage
            )
        } else {
            imageView.image = fallbackImage
        }

        setupFrames()
    }

    @objc private func soldFavoriteTapped() {
        delegate?.favoriteSoldViewDidTapSoldFavorite(self)
    }

    // MARK: - Public methods

    public func reloadAds() {
        adsGridView.reloadData()
    }

    public func updateItem(at index: Int, isFavorite: Bool) {
        adsGridView.updateItem(at: index, isFavorite: isFavorite)
    }

    public func hideAdsRetryButton() {
        adsRetryView.state = .hidden
    }

    public func showAdsRetryButton() {
        adsRetryView.state = .labelAndButton
    }
}

// MARK: - LoadingRetryViewDelegate

extension FavoriteSoldView: LoadingRetryViewDelegate {
    func loadingRetryViewDidSelectButton(_ view: LoadingRetryView) {
        adsRetryView.state = .loading
        delegate?.favoriteSoldViewDidTapRetryButton(self)
    }
}
