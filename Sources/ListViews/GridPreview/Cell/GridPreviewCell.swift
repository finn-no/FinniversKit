//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol GridPreviewCellDataSource {
    func loadImage(for model: GridPreviewListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func cancelLoadImage(for model: GridPreviewListViewModel, imageWidth: CGFloat)
}

public class GridPreviewCell: UICollectionViewCell {

    // MARK: - Internal properties

    private lazy var gridPreviewView: GridPreviewView = {
        let gridPreviewView = GridPreviewView()
        gridPreviewView.translatesAutoresizingMaskIntoConstraints = false
        gridPreviewView.dataSource = self
        return gridPreviewView
    }()

    // MARK: - External properties

    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor? {
        didSet {
            gridPreviewView.loadingColor = loadingColor
        }
    }

    /// A data source for the loading of the image
    public var dataSource: GridPreviewCellDataSource?

    /// Height in cell that is not image
    public static var nonImageHeight: CGFloat {
        return GridPreviewView.nonImageHeight
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
        contentView.addSubview(gridPreviewView)
        gridPreviewView.fillInSuperview()
    }

    // MARK: - Public

    /// Loads the image for the `model` if imagePath is set
    public func loadImage() {
        gridPreviewView.loadImage()
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        gridPreviewView.prepareForReuse()
    }

    // MARK: - Dependency injection

    public var model: GridPreviewListViewModel? {
        didSet {
            gridPreviewView.model = model
        }
    }
}

extension GridPreviewCell: GridPreviewViewDataSource {
    public func loadImage(for model: GridPreviewListViewModel, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        dataSource?.loadImage(for: model, imageWidth: imageWidth, completion: completion)
    }

    public func cancelLoadImage(for model: GridPreviewListViewModel, imageWidth: CGFloat) {
        dataSource?.cancelLoadImage(for: model, imageWidth: imageWidth)
    }
}
