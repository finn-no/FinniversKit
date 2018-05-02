//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AdCellDataSource {
    func adCell(_ adCell: AdCell, loadImageForModel model: AdsGridViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func adCell(_ adCell: AdCell, cancelLoadingImageForModel model: AdsGridViewModel, imageWidth: CGFloat)
}

public class AdCell: UICollectionViewCell {

    // MARK: - Internal properties

    private lazy var adView: AdView = {
        let adView = AdView()
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.dataSource = self
        return adView
    }()

    // MARK: - External properties

    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor? {
        didSet {
            adView.loadingColor = loadingColor
        }
    }

    /// A data source for the loading of the image
    public var dataSource: AdCellDataSource?

    /// Height in cell that is not image
    public static var nonImageHeight: CGFloat {
        return AdView.nonImageHeight
    }

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        contentView.addSubview(adView)
        adView.fillInSuperview()
    }

    // MARK: - Public

    /// Loads the image for the `model` if imagePath is set
    public func loadImage() {
        adView.loadImage()
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        adView.prepareForReuse()
    }

    // MARK: - Dependency injection

    public var model: AdsGridViewModel? {
        didSet {
            adView.model = model
        }
    }
}

extension AdCell: AdViewDataSource {
    public func adView(_ adView: AdView, loadImageForModel model: AdsGridViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.adCell(self, loadImageForModel: model, imageWidth: imageWidth, completion: completion)
    }

    public func adView(_ adView: AdView, cancelLoadingImageForModel model: AdsGridViewModel, imageWidth: CGFloat) {
        dataSource?.adCell(self, cancelLoadingImageForModel: model, imageWidth: imageWidth)
    }
}
