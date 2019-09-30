//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class VisibilityDrivenTitleView: UIView {

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

    public var minimumScaleFactor: CGFloat = 0 {
        didSet {
            label.minimumScaleFactor = minimumScaleFactor
        }
    }

    // MARK: - Private properties

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = textColor
        label.font = font
        label.numberOfLines = numberOfLines
        label.minimumScaleFactor = minimumScaleFactor
        return label
    }()

    private var isVisible = false {
        didSet {
            guard isVisible != oldValue else { return }
            animateVisibility()
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
        label.alpha = isVisible ? 1 : 0
    }

    // MARK: - Public methods

    public func setIsVisible(_ isVisible: Bool) {
        self.isVisible = isVisible
    }

    // MARK: - Private methods

    private func animateVisibility() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            self.label.alpha = self.isVisible ? 1 : 0
        })
    }
}
