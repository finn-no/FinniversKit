//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

extension SafetyElementsView {
    class CompactView: UIView {
        // MARK: - Private properties
        private lazy var stackView: UIStackView = {
            let stackView = UIStackView(withAutoLayout: true)
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            return stackView
        }()

        // MARK: - Initializers
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }

        // MARK: - Internal methods
        func configure(with viewModels: [SafetyElementViewModel], contentDelegate: SafetyElementContentViewDelegate?) {
            stackView.removeArrangedSubviews()

            viewModels.enumerated().forEach { (index, viewModel) in
                let subview = ElementView(withAutoLayout: true)
                subview.configure(with: viewModel, isLastElement: index == viewModels.count - 1)
                subview.delegate = contentDelegate
                stackView.addArrangedSubview(subview)
            }
        }

        // MARK: - Private methods
        private func setup() {
            backgroundColor = .background
            addSubview(stackView)
            stackView.fillInSuperview()
        }
    }
}
