//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public final class PhaseListView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    public func configure(with viewModels: [PhaseViewModel]) {
        
    }

    private func setup() {
        stackView.fillInSuperview()
    }
}
