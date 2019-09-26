//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class TitleView: UIView {

    // MARK: - Public properties

    var title: String = "" {
        didSet {
            label.text = title
            setNeedsLayout()
        }
    }

    // MARK: - Private properties

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .licorice
        label.font = UIFont.bodyStrong.withSize(20)
        return label
    }()

    private var percentVisible: CGFloat = 0 {
        didSet {
            label.frame.origin.y = yPositionAdjusted(from: percentVisible)
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = frame
        label.frame.origin.y = yPositionAdjusted(from: percentVisible)
    }

    // MARK: - Public methods

    func setPercentageVisible(_ percent: CGFloat) {
        percentVisible = max(0, min(percent, 1))
    }

    // MARK: - Private methods

    private func yPositionAdjusted(from percentVisible: CGFloat) -> CGFloat {
        let labelHeight = label.bounds.height
        return labelHeight - (labelHeight * percentVisible)
    }
}
