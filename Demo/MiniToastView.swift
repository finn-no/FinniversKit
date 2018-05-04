import FinniversKit

class MiniToastView: UIView {
    lazy var titleLabel: UILabel = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        titleLabel.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("") }
}
