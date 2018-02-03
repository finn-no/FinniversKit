//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

public class PreviewGridCellDemo: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {

        let previewCell = PreviewGridCell(frame: .zero)
        previewCell.translatesAutoresizingMaskIntoConstraints = false
        let model = PreviewDataModelFactory.create(numberOfModels: 1).first!
        let dataSource = APreviewGridCellDataSource()

        let multiplier = model.imageSize.height / model.imageSize.width
        let width: CGFloat = 200.0

        previewCell.loadingColor = .blue
        previewCell.dataSource = dataSource
        previewCell.model = model
        previewCell.loadImage()
        addSubview(previewCell)

        NSLayoutConstraint.activate([
            previewCell.topAnchor.constraint(equalTo: topAnchor),
            previewCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewCell.widthAnchor.constraint(equalToConstant: width),
            previewCell.heightAnchor.constraint(equalToConstant: (width * multiplier) + PreviewGridCell.nonImageHeight),
        ])
    }
}
