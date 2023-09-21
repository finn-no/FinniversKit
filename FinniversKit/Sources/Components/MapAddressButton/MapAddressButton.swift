import UIKit

public protocol MapAddressButtonDelegate: AnyObject {
    func mapAddressButtonWasSelected(_ button: MapAddressButton)
}

public class MapAddressButton: UIView {

    // MARK: - Public properties

    public weak var delegate: MapAddressButtonDelegate?

    // MARK: - Private properties

    private lazy var buttonStyle: Button.Style = {
        let buttonStyle = Button.Style.flat
        return buttonStyle.overrideStyle(
            margins: UIEdgeInsets(trailing: buttonStyle.margins.trailing)
        )
    }()

    private lazy var button: Button = {
        let button = MultilineButton(style: buttonStyle, size: .normal, withAutoLayout: true)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(vertical: 0, horizontal: .spacingS)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)

        let image = UIImage(named: .mapLocationPin)
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        button.imageView?.tintColor = button.style.textColor
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(button)
        button.fillInSuperview()
    }

    // MARK: - Public methods

    public func setTitle(_ title: String?) {
        button.setTitle(title, for: .normal)
    }

    public func setIcon(_ icon: UIImage?) {
        button.setImage(icon, for: .normal)
    }

    public func setTitleColor(_ titleColor: UIColor) {
        buttonStyle = buttonStyle.overrideStyle(textColor: titleColor)

        // Updating the style sets certain properties on the button back to their default values, including `titleEdgeInsets`.
        // Getting the current value here so we can set it back after changing the style.
        let titleEdgeInsets = button.titleEdgeInsets
        button.style = buttonStyle

        button.titleEdgeInsets = titleEdgeInsets
        button.imageView?.tintColor = buttonStyle.textColor
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.mapAddressButtonWasSelected(self)
    }
}
