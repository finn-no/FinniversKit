import FinniversKit
import FinnUI

public class ImageLinkViewDemo: UIView {

    // MARK: - Private properties

    private let viewModels: [ImageLinkViewModel] = [.videoLink, .virtualViewing]

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.spacing = .spacingM
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        let views = viewModels.map { viewModel -> ImageLinkView in
            let view = ImageLinkView(withAutoLayout: true)
            view.configure(with: viewModel)
            return view
        }

        addSubview(stackView)
        stackView.addArrangedSubviews(views)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
}

extension ImageLinkViewModel {
    static var videoLink = ImageLinkViewModel(
        description: "Videovisning",
        image: .imageWithColor(color: .salmon),
        overlayKind: .video
    )

    static var virtualViewing = ImageLinkViewModel(
        description: "360° visning",
        image: .imageWithColor(color: .mint),
        overlayKind: .virtualViewing
    )

    static var noOverlay = ImageLinkViewModel(
        description: "Bare et vanlig bilde",
        image: .imageWithColor(color: .primaryBlue)
    )
}

private extension UIImage {
    static func imageWithColor(color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
