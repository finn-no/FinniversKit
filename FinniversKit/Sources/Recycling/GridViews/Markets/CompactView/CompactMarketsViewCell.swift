import UIKit

class CompactMarketsViewCell: UICollectionViewCell {

    // MARK: - Internal properties

    var model: MarketsViewModel? {
        didSet {
            titleLabel.text = model?.title
            accessibilityLabel = model?.accessibilityLabel

            let showExternalLinkIcon = model?.showExternalLinkIcon ?? false
            externalLinkImageView.isHidden = !showExternalLinkIcon
        }
    }

    // MARK: - Private properties
    
    private lazy var sharpShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var smoothShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tileBackgroundColor
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: Self.itemSpacing, withAutoLayout: true)
        stackView.addArrangedSubviews([titleLabel, externalLinkImageView])
        stackView.alignment = .center
        return stackView
    }()

    private lazy var externalLinkImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .externalLinkColor
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: Self.titleLabelStyle, withAutoLayout: true)
        label.textAlignment = .left
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .tileBackgroundColor

        contentView.addSubview(sharpShadowView)
        contentView.addSubview(smoothShadowView)
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        
        containerView.fillInSuperview()
        stackView.fillInSuperview(insets: Self.contentInsets.forLayoutConstraints)

        NSLayoutConstraint.activate([
            externalLinkImageView.widthAnchor.constraint(equalToConstant: Self.externalLinkImageSize.width),
            externalLinkImageView.heightAnchor.constraint(equalToConstant: Self.externalLinkImageSize.height),
        ])
    }

    // MARK: - Superclass Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        accessibilityLabel = ""
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = frame.height / 2
        layer.cornerRadius = cornerRadius
        smoothShadowView.layer.cornerRadius = cornerRadius
        sharpShadowView.layer.cornerRadius = cornerRadius
        containerView.layer.cornerRadius = cornerRadius
        sharpShadowView.frame = contentView.bounds
        smoothShadowView.frame = contentView.bounds
        applyShadow()
    }
    
    func applyShadow() {
        sharpShadowView.applyShadow(ofType: .sharp)
        smoothShadowView.applyShadow(ofType: .smooth)
    }
    
    func removeShadow() {
        sharpShadowView.applyShadow(ofType: .none)
        smoothShadowView.applyShadow(ofType: .none)
    }
}

// MARK: - Size calculations

extension CompactMarketsViewCell {
    static let contentInsets = UIEdgeInsets(vertical: .spacingS, horizontal: 12)
    static let titleLabelStyle = Label.Style.captionStrong
    static let cellHeight: CGFloat = 34
    static let itemSpacing = CGFloat.spacingS
    static let externalLinkImageSize = CGSize(width: 12, height: 12)

    static func size(for model: MarketsViewModel) -> CGSize {
        var widths: [CGFloat] = [
            contentInsets.leading,
            itemSpacing,
            width(for: model.title)
        ]

        if model.showExternalLinkIcon {
            widths.append(contentsOf: [
                itemSpacing,
                externalLinkImageSize.width
            ])
        }

        widths.append(contentInsets.trailing)

        return CGSize(width: widths.reduce(0, +), height: cellHeight)
    }

    private static func width(for title: String) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: cellHeight)
        let boundingBox = title.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: titleLabelStyle.font],
            context: nil
        )

        return ceil(boundingBox.width)
    }
}

// MARK: - Private extensions

private extension UIView {
    
    enum ShadowType {
        case sharp
        case smooth
        case none
    }
    
    func applyShadow(ofType type: ShadowType) {
        self.layer.masksToBounds = false
        
        switch type {
        case .sharp:
            self.layer.shadowOpacity = 0.25
            self.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.layer.shadowColor = UIColor.tileSharpShadowColor.cgColor
            self.layer.shadowRadius = 1
            self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
        case .smooth:
            self.layer.shadowOpacity = 0.16
            self.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.layer.shadowColor = UIColor.tileSmoothShadowColor.cgColor
            self.layer.shadowRadius = 5
            self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.layer.cornerRadius).cgPath
        case .none:
            self.layer.shadowOpacity = 0.0
            self.layer.shadowOffset = .zero
            self.layer.shadowColor = nil
            self.layer.shadowRadius = 0
            self.layer.shadowPath = nil
        }
    }
}

// TODO: - These colors should be added to the ColorProvider at some point
private extension UIColor {
    class var externalLinkColor: UIColor {
        return .blueGray400
    }
    
    class var tileSharpShadowColor: UIColor {
        return .blueGray600
    }
    
    class var tileSmoothShadowColor: UIColor {
        return .blueGray600
    }
    
    class var tileBackgroundColor: UIColor {
        return .dynamicColorIfAvailable(defaultColor: .milk, darkModeColor: .blueGray700)
    }
}

private extension UIEdgeInsets {
    var forLayoutConstraints: UIEdgeInsets {
        UIEdgeInsets(top: top, leading: leading, bottom: -bottom, trailing: -trailing)
    }
}
