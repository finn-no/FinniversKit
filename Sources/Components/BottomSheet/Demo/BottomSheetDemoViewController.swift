//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FinniversKit

class BottomSheetDemoView: UIView {

    private lazy var topAnchorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .title3
        label.textColor = .stone
        label.text = "Top anchor"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var bottomAnchorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .title3
        label.textColor = .stone
        label.text = "Bottom anchor"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension BottomSheetDemoView {
    func setup() {
        addSubview(topAnchorLabel)
        addSubview(bottomAnchorLabel)
        NSLayoutConstraint.activate([
            topAnchorLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            topAnchorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bottomAnchorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
            bottomAnchorLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
