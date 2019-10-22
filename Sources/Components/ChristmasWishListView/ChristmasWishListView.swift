//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol ChristmasWishListViewDelegate: AnyObject {
    func christmasWishListViewDidSelectReadMore(_ view: ChristmasWishListView)
    func christmasWishListViewDidSelectCreateWishList(_ view: ChristmasWishListView)
    func christmasWishListViewDidSelectDone(_ view: ChristmasWishListView)
    func christmasWishListViewDidSelectClose(_ view: ChristmasWishListView)
}

public class ChristmasWishListView: UIView {
    // MARK: - Public properties
    public weak var delegate: ChristmasWishListViewDelegate?

    // MARK: - Private properties

    private lazy var bannerImageView: UIView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .christmasWishListBanner)
        return imageView
    }()

    private lazy var missionPopupView: MissionPopupView = {
        let view = MissionPopupView(
            withAutoLayout: true,
            headerView: bannerImageView,
            contentView: stackedContentView,
            actionView: stackedButtons
        )
        view.delegate = self

        return view
    }()

    private lazy var firstPageView: ContentView = {
        let view = ContentView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var secondPageView: ContentView = {
        let view = ContentView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    /// In order to create a sliding effect between the first and second page, I decided to use a view that stacks
    /// both pages along the Z-axis and use translation transforms along the X-axis to do the page animation
    private lazy var stackedContentView: UIView = {
        let view = UIView(withAutoLayout: true)

        view.addSubview(firstPageView)
        view.addSubview(secondPageView)

        firstPageView.fillInSuperview()
        secondPageView.fillInSuperview()

        return view
    }()

    private lazy var stackedButtons: UIView = {
        let view = UIView(withAutoLayout: true)

        let margin: CGFloat = .mediumLargeSpacing * 1.5
        view.layoutMargins = UIEdgeInsets(top: .mediumSpacing, leading: margin, bottom: margin, trailing: margin)

        view.addSubview(firstPageButton)
        view.addSubview(secondPageButton)

        firstPageButton.fillInSuperviewLayoutMargins()
        secondPageButton.fillInSuperviewLayoutMargins()

        return view
    }()

    private lazy var firstPageButton: ChristmasButton = {
        let button = ChristmasButton()
        button.addTarget(self, action: #selector(firstPageButtonTap), for: .touchUpInside)

        return button
    }()

    private lazy var secondPageButton: ChristmasButton = {
        let button = ChristmasButton()
        button.addTarget(self, action: #selector(secondPageButtonTap), for: .touchUpInside)

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

    // MARK: - Overrides
    public override func layoutSubviews() {
        super.layoutSubviews()

        secondPageView.transform = CGAffineTransform(translationX: bounds.width, y: 0)
        secondPageButton.transform = CGAffineTransform(translationX: bounds.width, y: 0)
    }

    // MARK: - Public methods

    public func configure(with viewModel: ChristmasWishListViewModel) {
        firstPageView.configure(with: viewModel.firstPage)
        secondPageView.configure(with: viewModel.secondPage)

        firstPageButton.setTitle(viewModel.firstPage.actionButtonTitle, for: .normal)
        firstPageButton.setImage(viewModel.firstPage.actionButtonIcon, for: .normal)

        secondPageButton.setTitle(viewModel.secondPage.actionButtonTitle, for: .normal)
        secondPageButton.setImage(viewModel.secondPage.actionButtonIcon, for: .normal)
    }

    // MARK: - Private methods

    private func setup() {
        addSubview(missionPopupView)
        missionPopupView.fillInSuperview()

        NSLayoutConstraint.activate([
            bannerImageView.heightAnchor.constraint(equalToConstant: 225),
        ])
    }

    @objc private func firstPageButtonTap() {
        UIView.animate(withDuration: 0.3) {
            self.firstPageButton.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
            self.secondPageButton.transform = .identity

            self.firstPageView.transform = CGAffineTransform(translationX: -self.bounds.width, y: 0)
            self.secondPageView.transform = .identity
        }
        delegate?.christmasWishListViewDidSelectCreateWishList(self)
    }

    @objc private func secondPageButtonTap() {
        delegate?.christmasWishListViewDidSelectDone(self)
    }
}

// MARK: - MissionPopupViewDelegate
extension ChristmasWishListView: MissionPopupViewDelegate {
    public func missionPopupViewDidSelectClose(_ view: MissionPopupView) {
        delegate?.christmasWishListViewDidSelectClose(self)
    }
}

// MARK: - ChristmasWishListContentViewDelegate
extension ChristmasWishListView: ChristmasWishListContentViewDelegate {
    func christmasWishListContentDidSelectAccessoryButton(_ view: ContentView) {
        delegate?.christmasWishListViewDidSelectReadMore(self)
    }
}
