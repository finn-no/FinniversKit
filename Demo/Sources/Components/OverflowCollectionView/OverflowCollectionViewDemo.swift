import UIKit
import FinniversKit
import DemoKit
import Warp

class OverflowCollectionViewDemo: UIView, Demoable {
    private lazy var overflowCollectionView = OverflowCollectionView(
        cellType: DemoCollectionViewCell.self,
        cellSpacing: .init(horizontal: Warp.Spacing.spacing100, vertical: Warp.Spacing.spacing50),
        delegate: self,
        withAutoLayout: true
    )

    private let models: [String] = [
        "Lorem",
        "Ipsum",
        "Dolor",
        "Sit",
        "Amet",
        "Consectetur",
        "Adipiscing",
        "Elit",
        "Maecenas",
        "Molestie",
        "Leo"
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(overflowCollectionView)
        overflowCollectionView.fillInSuperview(margin: Warp.Spacing.spacing200)
        overflowCollectionView.configure(with: models)
    }
}

// MARK: - OverflowCollectionViewDelegate

extension OverflowCollectionViewDemo: OverflowCollectionViewDelegate {
    func overflowCollectionView<Cell>(
        _ view: OverflowCollectionView<Cell>,
        didSelectItemAtIndex index: Int
    ) where Cell: OverflowCollectionViewCell {
        print("👉 Did select item at index: \(index)")
    }
}

// MARK: - Private types

private class DemoCollectionViewCell: UICollectionViewCell, OverflowCollectionViewCell {
    typealias Model = String

    // MARK: - Private properties

    private static let labelStyle = Warp.Typography.body
    private static let margins = UIEdgeInsets(vertical: Warp.Spacing.spacing100, horizontal: Warp.Spacing.spacing200)
    private lazy var label = Label(style: .body, withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .backgroundInfoSubtle
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.margins.top),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.margins.leading),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.margins.trailing),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Self.margins.bottom)
        ])
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = min(contentView.bounds.height, contentView.bounds.width) / 2
        contentView.layer.borderColor = UIColor.border.cgColor
        label.textColor = .text
    }

    // MARK: - OverflowCollectionViewCell

    static func size(using model: String) -> CGSize {
        let font = Self.labelStyle.uiFont
        let margins = Self.margins

        let width = model.width(withConstrainedHeight: .infinity, font: font) + (margins.leading + margins.trailing)
        let height = model.height(withConstrainedWidth: .infinity, font: font) + (margins.top + margins.bottom)

        return CGSize(width: width, height: height)
    }

    func configure(using model: String) {
        label.text = model
    }
}
