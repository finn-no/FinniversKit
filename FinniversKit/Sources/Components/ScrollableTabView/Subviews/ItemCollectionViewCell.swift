import UIKit

extension ScrollableTabView {
    class ItemCollectionViewCell: UICollectionViewCell {

        // MARK: - Internal properties

        var item: ScrollableTabViewModel.Item?

        static var cellHeight: CGFloat {
            labelHeight + indicatorHeight + (verticalPadding * 2)
        }

        override var isSelected: Bool {
            didSet {
                updateSelection(animate: true)
            }
        }

        // MARK: - Private properties

        private lazy var titleLabel = Label(style: Self.labelStyle, withAutoLayout: true)
        private static let labelStyle = Label.Style.captionStrong
        private static let indicatorHeight: CGFloat = 4
        private static let verticalPadding = CGFloat.spacingS

        private static var labelHeight: CGFloat {
            "I".height(withConstrainedWidth: .greatestFiniteMagnitude, font: Self.labelStyle.font)
        }

        private lazy var indicatorView: UIView = {
            let indicatorView = UIView(withAutoLayout: true)
            indicatorView.backgroundColor = .primaryBlue
            return indicatorView
        }()

        // MARK: - Init

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }

        required init?(coder: NSCoder) {
            fatalError()
        }

        // MARK: - Setup

        private func setup() {
            isAccessibilityElement = true
            accessibilityTraits = [.button]

            contentView.addSubview(titleLabel)
            contentView.addSubview(indicatorView)

            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.verticalPadding),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -(Self.verticalPadding + Self.indicatorHeight)),

                indicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                indicatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                indicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                indicatorView.heightAnchor.constraint(equalToConstant: Self.indicatorHeight),
            ])
        }

        // MARK: - Internal methods

        func configure(item: ScrollableTabViewModel.Item) {
            self.item = item
            titleLabel.text = item.title
            updateSelection(animate: false)
            accessibilityLabel = item.title
        }

        // MARK: - Private methods

        private func updateSelection(animate: Bool) {
            if isSelected {
                accessibilityTraits.insert(.selected)
            } else {
                accessibilityTraits.remove(.selected)
            }
            let animationDuration: TimeInterval = animate ? 0.15 : 0

            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
                UIView.transition(with: self.titleLabel, duration: animationDuration, options: .transitionCrossDissolve, animations: {
                    self.titleLabel.textColor = self.isSelected ? .textPrimary : .stone
                })
                self.indicatorView.alpha = self.isSelected ? 1 : 0
            })
        }
    }
}
