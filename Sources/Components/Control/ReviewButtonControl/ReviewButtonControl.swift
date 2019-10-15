//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol ReviewButtonControlDelegate: AnyObject {
    func reviewButtonControl(_ reviewButtonControl: ReviewButtonControl, giveReviewWasTapped startReview: Bool)
}

public final class ReviewButtonControl: UIControl {
    // MARK: - Public

    public weak var delegate: ReviewButtonControlDelegate?
    public var text: String = "" {
        didSet {
            titleLabel.text = text
            accessibilityLabel = text
        }
    }

    // MARK: - Private

    private lazy var imageView: UIImageView = {
        let image = UIImage(named: .rate).withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.tintColor = .bgPrimary
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .bgPrimary
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Override

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.alpha = 0.9
        self.delegate?.reviewButtonControl(self, giveReviewWasTapped: true)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.alpha = 1.0
    }

    // MARK: - Private

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 8
        backgroundColor = .btnPrimary

        addSubview(titleLabel)
        addSubview(imageView)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -.smallSpacing)
        ])
    }
}
