//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class AnimatedRadioButtonView: AnimatedSelectionView {

    public required init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        image = .brandRadioButtonUnselected
        highlightedImage = .brandRadioButtonSelected

        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 24),
            heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
