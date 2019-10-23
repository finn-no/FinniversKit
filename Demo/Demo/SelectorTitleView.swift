import FinniversKit

public protocol SelectorTitleViewDelegate: AnyObject {
    func selectorTitleViewDidSelectButton(_ selectorTitleView: SelectorTitleView)
}

public class SelectorTitleView: UIView {
    public weak var delegate: SelectorTitleViewDelegate?

    private lazy var button: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.titleLabel?.font = UIFont.bodyStrong.withSize(17).scaledFont(forTextStyle: .footnote)
        button.titleLabel?.adjustsFontForContentSizeCategory = true

        let spacing = .smallSpacing / 2

        button.semanticContentAttribute = .forceRightToLeft
        button.imageEdgeInsets = UIEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: -spacing)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, leading: -spacing, bottom: 0, trailing: spacing)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)

        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: .arrowDown), for: .normal)
        addSubview(button)
        button.fillInSuperview()
        updateColors()
    }

    public var title: String? {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }

    @objc private func handleButtonTap() {
        delegate?.selectorTitleViewDidSelectButton(self)
    }

    private func updateColors() {
        let buttonColor: UIColor = .textAction
        let interfaceBackgroundColor: UIColor = .bgPrimary

        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonColor.withAlphaComponent(0.5), for: .highlighted)
        button.setTitleColor(buttonColor.withAlphaComponent(0.5), for: .selected)
        button.setTitleColor(.textDisabled, for: .disabled)
        button.tintColor = buttonColor
        backgroundColor = interfaceBackgroundColor
    }
}
