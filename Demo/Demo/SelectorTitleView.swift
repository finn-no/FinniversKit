import FinniversKit

protocol SelectorTitleViewDelegate: AnyObject {
    func selectorTitleViewDidSelectButton(_ selectorTitleView: SelectorTitleView)
}

class SelectorTitleView: UIView {
    weak var delegate: SelectorTitleViewDelegate?

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

    func setup() {
        button.setImage(UIImage(named: .arrowDown), for: .normal)
        addSubview(button)
        button.fillInSuperview()
    }

    var title: String? {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }

    @objc private func handleButtonTap() {
        delegate?.selectorTitleViewDidSelectButton(self)
    }

    func updateColors(for traitCollection: UITraitCollection) {
        let userInterfaceStyle = UserInterfaceStyle(traitCollection: traitCollection)
        let buttonColor = userInterfaceStyle.foregroundTintColor
        button.setTitleColor(buttonColor, for: .normal)
        button.setTitleColor(buttonColor.withAlphaComponent(0.5), for: .highlighted)
        button.setTitleColor(buttonColor.withAlphaComponent(0.5), for: .selected)
        button.setTitleColor(buttonColor.withAlphaComponent(0.5), for: .disabled)
        button.tintColor = buttonColor
        backgroundColor = userInterfaceStyle.foregroundColor
    }
}
