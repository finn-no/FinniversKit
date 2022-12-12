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
            margins: UIEdgeInsets(
                top: buttonStyle.margins.top,
                leading: 0,
                bottom: buttonStyle.margins.bottom,
                trailing: buttonStyle.margins.trailing
            )
        )
    }()

    private lazy var button: Button = {
        let button = MultilineButton(style: buttonStyle, size: .normal, withAutoLayout: true)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(vertical: 0, horizontal: .spacingS)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)

        button.setImage(UIImage(named: .mapLocationPin), for: .normal)
        button.imageView?.tintColor = button.style.textColor
        button.adjustsImageWhenHighlighted = false
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

    public func setTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.mapAddressButtonWasSelected(self)
    }
}
