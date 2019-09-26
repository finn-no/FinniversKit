//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class PercentageDrivenTitleView: UIView {

    // MARK: - Public properties

    public var title: String = "" {
        didSet {
            label.text = title
            setNeedsLayout()
        }
    }

    public var font: UIFont = .bodyStrong {
        didSet {
            label.font = font
            setNeedsLayout()
        }
    }

    public var textColor: UIColor = .licorice {
        didSet {
            label.textColor = textColor
        }
    }

    public var numberOfLines: Int = 1 {
        didSet {
            label.numberOfLines = numberOfLines
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
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
        label.frame.origin.y = yPositionAdjusted(from: percentVisible)
    }

    // MARK: - Public methods

    public func setPercentageVisible(_ percent: CGFloat) {
        percentVisible = max(0, min(percent, 1))
    }

    // MARK: - Private methods

    private func yPositionAdjusted(from percentVisible: CGFloat) -> CGFloat {
        let labelHeight = label.bounds.height
        return labelHeight - (labelHeight * percentVisible)
    }
}
