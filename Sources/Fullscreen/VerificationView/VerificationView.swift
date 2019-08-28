//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public protocol VerificationViewDelegate: AnyObject {
    func didTapVerificationButton(_ : VerificationView)
    func didDismissVerificationView(_ : VerificationView)
}

public class VerificationView: UIView {
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = 0
        return blurEffectView
    }()

    private lazy var verificationCardView: VerificationCardView = {
        let view = VerificationCardView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
    private var verificationCardViewTopAnchor: NSLayoutConstraint?

    public weak var delegate: VerificationViewDelegate?

    public var model: VerificationViewModel? {
        didSet {
            verificationCardView.model = model
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public func show() {
        if verificationCardViewTopAnchor == nil {
            verificationCardViewTopAnchor = verificationCardView.topAnchor.constraint(equalTo: centerYAnchor)
            verificationCardViewTopAnchor?.isActive = true
            verificationCardView.frame.origin.y = UIScreen.main.bounds.height
        }

        UIView.animate(withDuration: 0.3) {
            self.blurEffectView.alpha = 0.4
            self.verificationCardView.frame.origin.y = self.bounds.midY
        }
    }

    public func dismiss() {
        UIView.animate(withDuration: 0.3) {
            self.blurEffectView.alpha = 0
            self.verificationCardView.frame.origin.y = UIScreen.main.bounds.height
        }
    }
}

private extension VerificationView {
    func setup() {
        backgroundColor = .clear

        addGestureRecognizer(tapGesture)

        addSubview(blurEffectView)
        blurEffectView.fillInSuperview()

        addSubview(verificationCardView)
        NSLayoutConstraint.activate([
            verificationCardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            verificationCardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            verificationCardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc func didTap() {
        dismiss()
        delegate?.didDismissVerificationView(self)
    }
}

extension VerificationView: VerificationCardViewDelegate {
    public func didTapVerificationButton(_: VerificationCardView) {
        delegate?.didTapVerificationButton(self)
    }
}
