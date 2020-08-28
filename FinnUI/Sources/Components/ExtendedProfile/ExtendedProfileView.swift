//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public protocol ExtendedProfileViewDelegate: AnyObject {
    func extendedProfileViewDidSelectLink(atIndex: Int)
    func extendedProfileViewDidSelectActionButton()
}

public class ExtendedProfileView: UIView {

    private enum State {
        case notExpandable
        case expanded
        case contracted
    }

    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var sloganBoxView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(updateExpandState)
        )
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()

    private lazy var sloganLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    private lazy var toggleButton: ToggleButton = {
        let button = ToggleButton(frame: CGRect(x: 0, y: 0,
                width: ExtendedProfileView.toggleButtonSize,
                height: ExtendedProfileView.toggleButtonSize
            )
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        button.addTarget(self, action: #selector(updateExpandState), for: .touchUpInside)
        return button
    }()

    private lazy var bodyView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.isHidden = true
        return view
    }()

    private lazy var linksStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.alignment = .fill
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var actionButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var footerImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private static let toggleButtonSize: CGFloat = 30

    private var state: State = .contracted

    public weak var delegate: ExtendedProfileViewDelegate?

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(headerImageView)
        addSubview(sloganBoxView)
        addSubview(bodyView)

        sloganBoxView.addSubview(sloganLabel)
        sloganBoxView.addSubview(toggleButton)

        bodyView.addSubview(linksStackView)
        bodyView.addSubview(actionButton)
        bodyView.addSubview(footerImageView)

        NSLayoutConstraint.activate([
            headerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImageView.topAnchor.constraint(equalTo: topAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 150),

            sloganBoxView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sloganBoxView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor),
            sloganBoxView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sloganBoxView.heightAnchor.constraint(equalToConstant: 50),

            sloganLabel.centerXAnchor.constraint(equalTo: sloganBoxView.centerXAnchor),
            sloganLabel.centerYAnchor.constraint(equalTo: sloganBoxView.centerYAnchor),

            toggleButton.centerYAnchor.constraint(equalTo: sloganBoxView.centerYAnchor),
            toggleButton.heightAnchor.constraint(equalToConstant: ExtendedProfileView.toggleButtonSize),
            toggleButton.widthAnchor.constraint(equalToConstant: ExtendedProfileView.toggleButtonSize),
            toggleButton.trailingAnchor.constraint(equalTo: sloganBoxView.trailingAnchor, constant: -.spacingS),

            bodyView.topAnchor.constraint(equalTo: sloganBoxView.bottomAnchor),
            bodyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: trailingAnchor),

            linksStackView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: .spacingS),
            linksStackView.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: .spacingM),
            linksStackView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -.spacingS),

            actionButton.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: .spacingS),
            actionButton.topAnchor.constraint(equalTo: linksStackView.bottomAnchor, constant: .spacingM),
            actionButton.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -.spacingS),

            footerImageView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: .spacingL),
            footerImageView.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: .spacingL),
            footerImageView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -.spacingL),
            footerImageView.heightAnchor.constraint(equalToConstant: 200),
            footerImageView.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -.spacingL),
        ])
    }

    // MARK: - Public methods

    public func configue(
        with viewModel: ExtendedProfileViewModel,
        showHeaderImage: Bool,
        isExpandable: Bool
    ) {
        if showHeaderImage {
            headerImageView.image = viewModel.headerImage
            headerImageView.backgroundColor = viewModel.headerBackgroundColor
        } else {
            headerImageView.isHidden = true
        }

        if isExpandable {
            toggleButton.tintColor = viewModel.sloganBackgroundColor.contrastingColor()
            updateToggleButtonState()
        } else {
            state = .notExpandable
            toggleButton.isHidden = true
            bodyView.isHidden = false
            sloganBoxView.isUserInteractionEnabled = false
        }

        sloganLabel.text = viewModel.sloganText
        sloganBoxView.backgroundColor = viewModel.sloganBackgroundColor
        sloganLabel.textColor = viewModel.sloganTextColor

        bodyView.backgroundColor = viewModel.mainBackgroundColor

        for linkTitle in viewModel.linkTitles {
            addButton(withTitle: linkTitle, textColor: viewModel.mainTextColor, to: linksStackView)

            if linkTitle != viewModel.linkTitles.last {
                addSeparatorLine(withColor: viewModel.mainTextColor, to: linksStackView)
            }
        }

        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)

        if let footerImage = viewModel.footerImage {
            footerImageView.image = footerImage
        } else {
            footerImageView.isHidden = true
        }
    }

    // MARK: - Private methods

    private func addButton(withTitle title: String, textColor: UIColor, to stackView: UIStackView) {
        let style = Button.Style.link.overrideStyle(
            textColor: textColor,
            highlightedTextColor: textColor.withAlphaComponent(0.6)
        )
        let button = Button(style: style, withAutoLayout: true)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(linkTapped(_:)), for: .touchUpInside)

        stackView.addArrangedSubview(button)
    }

    private func addSeparatorLine(withColor color: UIColor, to stackView: UIStackView) {
        let separator = UIView(withAutoLayout: true)
        separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        separator.backgroundColor = color.withAlphaComponent(0.5)
        stackView.addArrangedSubview(separator)
    }

    private func updateToggleButtonState() {
        guard state != .notExpandable else { return }

        toggleButton.setExpanded(state == .expanded, animated: true)
        bodyView.isHidden = state != .expanded
    }

    // MARK: - Actions

    @objc private func updateExpandState() {
        guard state != .notExpandable else { return }
        state = state == .expanded ? .contracted : .expanded
        updateToggleButtonState()
    }

    @objc private func linkTapped(_ sender: Button) {
        guard let index = linksStackView.arrangedSubviews.filter({ $0 is Button }).firstIndex(of: sender) else {
            return
        }
        delegate?.extendedProfileViewDidSelectLink(atIndex: index)
    }

    @objc private func actionButtonTapped() {
        delegate?.extendedProfileViewDidSelectActionButton()
    }
}

// MARK: - Private classes

private class ToggleButton: UIButton {
    private var expanded = false {
        didSet {
            shapeLayer.path = expanded ? collapsePath() : expandPath()
        }
    }

    private let shapeLayer: CAShapeLayer
    override var isHighlighted: Bool {
        didSet {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            shapeLayer.strokeColor = (isHighlighted ? UIColor.gray : tintColor).cgColor
            CATransaction.commit()
        }
    }

    private let iconView: UIView

    override init(frame: CGRect) {
        iconView = UIView(frame: frame)
        shapeLayer = CAShapeLayer()
        super.init(frame: frame)

        shapeLayer.strokeColor = tintColor.cgColor
        shapeLayer.lineWidth = frame.width * 0.0454
        shapeLayer.fillColor = nil
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        shapeLayer.frame = frame
        shapeLayer.isGeometryFlipped = true
        iconView.layer.addSublayer(shapeLayer)
        iconView.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin]
        iconView.isUserInteractionEnabled = false
        addSubview(iconView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame.origin = CGPoint(x: bounds.width - iconView.frame.width, y: 0)
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        shapeLayer.strokeColor = tintColor.cgColor
    }

    func setExpanded(_ expanded: Bool, animated: Bool) {
        if animated {
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = 0.23
            animation.fromValue = expanded ? expandPath() : collapsePath()
            animation.toValue = expanded ? collapsePath() : expandPath()
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            shapeLayer.add(animation, forKey: "pathAnimation")
        }
        self.expanded = expanded
    }

    private func expandPath() -> CGPath {
        let path = circlePath()

        let icon = UIBezierPath()
        let rect = path.bounds.insetBy(dx: 4, dy: 4)
        let visualCompensation: CGFloat = 1
        icon.move(to: CGPoint(x: rect.minX, y: rect.midY + visualCompensation))
        icon.addLine(to: CGPoint(x: rect.midX, y: rect.midY - (rect.height / 3) + visualCompensation))
        icon.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + visualCompensation))

        path.append(icon)

        return path.cgPath
    }

    private func collapsePath() -> CGPath {
        let path = circlePath()

        let icon = UIBezierPath()
        let rect = path.bounds.insetBy(dx: 4, dy: 4)
        icon.move(to: CGPoint(x: rect.minX, y: rect.midY))
        icon.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        icon.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))

        path.append(icon)

        return path.cgPath
    }

    private func circlePath() -> UIBezierPath {
        let rect = shapeLayer.bounds.insetBy(dx: shapeLayer.bounds.width * 0.27, dy: shapeLayer.bounds.height * 0.27)
        let path = UIBezierPath()
        path.addArc(withCenter: shapeLayer.position,
                    radius: rect.width / 2,
                    startAngle: 0,
                    endAngle: CGFloat((360.0 * Double.pi) / 180.0),
                    clockwise: true)
        path.close()
        return path
    }
}

// MARK: - Private extensions

private extension UIColor {
    var luminance: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)

        // http://en.wikipedia.org/wiki/Luma_(video)
        // Y = 0.2126 R + 0.7152 G + 0.0722 B
        return 0.2126 * red + 0.7152 * green + 0.0722 * blue
    }

    func contrastingColor() -> UIColor {
        if luminance > 0.6 {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
}
