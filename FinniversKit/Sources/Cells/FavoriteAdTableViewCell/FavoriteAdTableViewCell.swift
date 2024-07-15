//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public protocol FavoriteAdTableViewCellDelegate: AnyObject {
    func favoriteAdTableViewCell(_ cell: FavoriteAdTableViewCell, didSelectMoreButton button: UIButton)
}

public class FavoriteAdTableViewCell: UITableViewCell {

    // MARK: - Public properties

    public weak var delegate: FavoriteAdTableViewCellDelegate?

    public weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            adView.remoteImageViewDataSource = remoteImageViewDataSource
        }
    }

    var isMoreButtonHidden = false {
        didSet {
            adView.isMoreButtonHidden = isMoreButtonHidden
        }
    }

    // MARK: - Private properties

    private lazy var adView: FavoriteAdView = {
        let view = FavoriteAdView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        adView.resetContent()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        adView.resetBackgroundColors()
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        adView.resetBackgroundColors()
    }

    public override func didTransition(to state: StateMask) {
        super.didTransition(to: state)
        let isEditing = state.contains(.showingEditControl)

        adView.isMoreButtonHidden = isEditing || isMoreButtonHidden
    }

    // MARK: - Public methods

    public func configure(with viewModel: FavoriteAdViewModel) {
        separatorInset = .leadingInset(Warp.Spacing.spacing400 + FavoriteAdView.adImageWidth)
        adView.configure(with: viewModel)
    }

    public func loadImage() {
        adView.loadImage()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .background
        setDefaultSelectedBackgound()
        contentView.addSubview(adView)
        adView.fillInSuperview()
    }
}

// MARK: - FavoriteAdViewDelegate

extension FavoriteAdTableViewCell: FavoriteAdViewDelegate {
    func favoriteAdView(_ view: FavoriteAdView, didSelectMoreButton button: UIButton) {
        delegate?.favoriteAdTableViewCell(self, didSelectMoreButton: button)
    }
}
