//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class CarouselViewDemoCell: CarouselViewCell {

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    private lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .title1
        label.textColor = .milk
        label.backgroundColor = .primaryBlue
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
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

private extension CarouselViewDemoCell {
    func setup() {
        contentView.addSubview(label)
        label.fillInSuperview(
            insets: UIEdgeInsets(
                top: .mediumLargeSpacing,
                leading: .mediumLargeSpacing,
                bottom: -.mediumLargeSpacing,
                trailing: -.mediumLargeSpacing
            )
        )
    }
}
