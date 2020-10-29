//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public class MessageUserRequiredView: UIView {
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: .messageUserRequired).withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.tintColor = .iconSecondary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var messageView: UITextView = {
        let view = UITextView(withAutoLayout: true)
        let style = Label.Style.bodyStrong
        view.font = style.font
        view.textColor = .textPrimary
        view.textAlignment = .center
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.isEditable = false
        view.isUserInteractionEnabled = false
        view.adjustsFontForContentSizeCategory = true
        view.textContainerInset = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        view.textContainer.widthTracksTextView = true
        view.textContainer.heightTracksTextView = true
        return view
    }()

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        backgroundColor = .bgPrimary
        addSubview(imageView)
        addSubview(messageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            imageView.widthAnchor.constraint(equalToConstant: 64),

            messageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .spacingM),
            messageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            messageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            messageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: .spacingS)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(_ message: String) {
        messageView.text = message
    }
}
