//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol MessageUserRequiredViewDelegate: AnyObject {
    func didTapActionButton(_ sender: Button)
}

public class MessageUserRequiredView: UIView {
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: .messageUserRequired).withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.tintColor = .icon
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var messageView: UITextView = {
        let view = UITextView(withAutoLayout: true)
        let style = Label.Style.bodyStrong
        view.font = style.font
        view.textColor = .text
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

    private lazy var actionButton: Button = {
        let button = Button(style: .default, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)
        return button
    }()

    public weak var delegate: MessageUserRequiredViewDelegate?

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .background
        addSubview(imageView)
        addSubview(messageView)
        addSubview(actionButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            imageView.widthAnchor.constraint(equalToConstant: 64),

            messageView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .spacingM),
            messageView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor, constant: .spacingS),
            messageView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor, constant: -.spacingS),

            actionButton.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: .spacingL),
            actionButton.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: .spacingM),
            actionButton.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -.spacingM),
        ])
    }

    @objc private func handleActionButtonTap(_ sender: Button) {
        delegate?.didTapActionButton(sender)
    }

    public func configure(_ message: String, buttonText text: String) {
        messageView.text = message
        actionButton.setTitle(text, for: .normal)
    }
}
