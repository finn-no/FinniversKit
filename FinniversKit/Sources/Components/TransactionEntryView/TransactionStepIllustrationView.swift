import Foundation

class TransactionStepIllustrationView: UIView {

    // MARK: - Private properties

    private let circleSize: CGFloat = .spacingS + .spacingXS
    private lazy var line = UIView(withAutoLayout: true)

    private lazy var circleView: UIView = {
        let circle = UIView(withAutoLayout: true)
        circle.layer.cornerRadius = circleSize / 2
        circle.layer.borderWidth = 2
        return circle
    }()

    private lazy var gradientLayer: CALayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = line.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 1]
        return gradientLayer
    }()


    // MARK: - Init

    init(color: UIColor, withAutoLayout: Bool = false) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        circleView.layer.borderColor = color.cgColor
        line.backgroundColor = color
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(circleView)
        addSubview(line)

        NSLayoutConstraint.activate([
            circleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            circleView.topAnchor.constraint(equalTo: topAnchor),
            circleView.trailingAnchor.constraint(equalTo: trailingAnchor),

            line.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: .spacingXXS),
            line.centerXAnchor.constraint(equalTo: centerXAnchor),
            line.widthAnchor.constraint(equalToConstant: 2),
            line.bottomAnchor.constraint(equalTo: bottomAnchor),

            circleView.widthAnchor.constraint(equalToConstant: circleSize),
            circleView.heightAnchor.constraint(equalToConstant: circleSize),
        ])
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = line.bounds
        line.layer.mask = gradientLayer
    }
}
