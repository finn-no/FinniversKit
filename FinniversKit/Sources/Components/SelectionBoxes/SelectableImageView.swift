import Foundation

public class SelectableImageView: UIImageView {
    public var isSelected: Bool {
        isHighlighted
    }

    public init(
        unselectedImage: UIImage,
        selectedImage: UIImage
    ) {
        super.init(frame: .zero)
        image = unselectedImage
        highlightedImage = selectedImage
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 24),
            heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    public func configure(isSelected: Bool) {
        isHighlighted = isSelected
    }
}
