//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import FinniversKit

class LoanCalculatorDemoView: UIView {
    private lazy var loanCalculatorView: LoanCalculatorView = {
        let view = LoanCalculatorView(withAutoLayout: true)
        view.layer.cornerRadius = .mediumSpacing
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(loanCalculatorView)
        NSLayoutConstraint.activate([
            loanCalculatorView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1, constant: -.largeSpacing),
            loanCalculatorView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 1, constant: -.largeSpacing),
            loanCalculatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loanCalculatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
