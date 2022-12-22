import UIKit

extension JobKeyInfoView {
    class Separator: UIView {

        // MARK: - Init

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

        // MARK: - Setup

        private func setup() {
            backgroundColor = .tableViewSeparator
            heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        }
    }

}
