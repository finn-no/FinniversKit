//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol MissionPopupViewDelegate: AnyObject {
    func missionPopupViewDidSelectClose(_ view: MissionPopupView)
}

/// An attempt to create a generic pop-up like container to create views like the klimabrølet pop up
public class MissionPopupView: UIView {
    // MARK: - Public properties
    public weak var delegate: MissionPopupViewDelegate?

    // MARK: - Private properties
    private var headerView: UIView
    private var contentView: UIView
    private var actionView: UIView

    private var shadowAnimationDuration = 0.12
    private var shadowOpacityLevel: Float = 0.2

    private lazy var closeButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = .background
        button.setImage(UIImage(named: .cross), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.contentEdgeInsets = UIEdgeInsets(all: 6)
        button.addTarget(self, action: #selector(handleTapOnCloseButton), for: .touchUpInside)

        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.bounces = true
        scrollView.contentInset = UIEdgeInsets(bottom: .spacingXL)
        scrollView.delaysContentTouches = false
        scrollView.delegate = self
        return scrollView
    }()

    private lazy var scrollableContentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.accessibilityLabel = "scrollableContent"
        return view
    }()

    // MARK: - Initializers
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Use the initializer init(withAutoLayout:headerView:contentView:actionView) instead")
    }

    public init(withAutoLayout: Bool, headerView: UIView, contentView: UIView, actionView: UIView) {
        self.headerView = headerView
        self.contentView = contentView
        self.actionView = actionView
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    // MARK: - Overrides
    public override func layoutSubviews() {
        super.layoutSubviews()
        closeButton.layer.cornerRadius = closeButton.bounds.width / 2.0
    }

    // MARK: - Private methods
    private func setup() {
        backgroundColor = .background
        layer.cornerRadius = 20
        clipsToBounds = true

        scrollableContentView.addSubview(headerView)
        scrollableContentView.addSubview(contentView)

        scrollView.addSubview(scrollableContentView)

        addSubview(scrollView)
        addSubview(actionView)
        addSubview(closeButton)

        actionView.setContentHuggingPriority(.required, for: .vertical)
        actionView.backgroundColor = backgroundColor
        scrollableContentView.fillInSuperview()

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: scrollableContentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: scrollableContentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: contentView.topAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollableContentView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollableContentView.bottomAnchor),

            scrollableContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollableContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),

            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: actionView.topAnchor),

            actionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @objc private func handleTapOnCloseButton() {
        delegate?.missionPopupViewDidSelectClose(self)
    }
}

// MARK: - UIScrollViewDelegate
extension MissionPopupView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height < scrollableContentView.intrinsicContentSize.height {
            animateShadow(fromValue: shadowOpacityLevel, toValue: 0, duration: shadowAnimationDuration)
        } else {
            animateShadow(fromValue: 0, toValue: shadowOpacityLevel, duration: shadowAnimationDuration)
        }
    }

    func animateShadow(fromValue from: Float, toValue to: Float, duration: Double) {
        guard actionView.layer.shadowOpacity != to else { return }
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        actionView.layer.add(animation, forKey: nil)
        actionView.layer.shadowOpacity = to
    }
}
