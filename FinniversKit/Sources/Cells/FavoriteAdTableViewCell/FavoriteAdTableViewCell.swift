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

    private lazy var swipeHighlightBackgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .clear
        view.layer.cornerRadius = Warp.Spacing.spacing300
        view.layer.cornerCurve = .continuous
        return view
    }()

    private var normalSeparatorInset: UIEdgeInsets?

    // MARK: - Init

    public override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        if let normalSeparatorInset {
            separatorInset = normalSeparatorInset
        }
        normalSeparatorInset = nil
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

    public override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        swipeHighlightBackgroundView.backgroundColor = state.isSwiped ? Warp.UIToken.backgroundSubtle : .clear
        updateSeparator(for: state)
    }

    // MARK: - Public methods

    public func configure(with viewModel: FavoriteAdViewModel) {
        separatorInset = .leadingInset(Warp.Spacing.spacing400 + FavoriteAdView.adImageWidth)
        normalSeparatorInset = separatorInset
        updateSeparator(for: configurationState)
        adView.configure(with: viewModel)
    }

    public func loadImage() {
        adView.loadImage()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .background
        setDefaultSelectedBackgound()
        contentView.addSubview(swipeHighlightBackgroundView)
        contentView.addSubview(adView)

        swipeHighlightBackgroundView.fillInSuperview()
        adView.fillInSuperview()
    }

    private func updateSeparator(for state: UICellConfigurationState) {
        guard let normalSeparatorInset else { return }
        separatorInset = state.isSwiped ? .leadingInset(.greatestFiniteMagnitude) : normalSeparatorInset
    }

}

// MARK: - FavoriteAdViewDelegate

extension FavoriteAdTableViewCell: FavoriteAdViewDelegate {
    func favoriteAdView(_ view: FavoriteAdView, didSelectMoreButton button: UIButton) {
        delegate?.favoriteAdTableViewCell(self, didSelectMoreButton: button)
    }
}
