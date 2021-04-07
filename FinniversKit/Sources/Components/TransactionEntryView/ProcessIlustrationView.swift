import Foundation

class ProcessIllustrationView: UIView {

    private lazy var circleView: UIView = {
        let circle = UIView(withAutoLayout: true)
        circle.layer.cornerRadius = circleWidth/2
        circle.layer.borderWidth = 2
        return circle
    }()

    private lazy var line: UIView = {
        let line = UIView(withAutoLayout: true)
        return line
    }()

    private lazy var gradientLayer: CALayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = line.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 1]
        return gradientLayer
    }()

    private let circleWidth: CGFloat = .spacingS + .spacingXS

    // MARK: - Init

    init(color: UIColor) {
        super.init(frame: .zero)
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

            circleView.widthAnchor.constraint(equalToConstant: circleWidth),
            circleView.heightAnchor.constraint(equalToConstant: circleWidth),
        ])
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = line.bounds
        line.layer.mask = gradientLayer
    }
}
