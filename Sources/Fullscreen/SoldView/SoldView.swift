//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct SoldViewModel {
    let image: UIImage
    let text: String
    let button: String

    public init(image: UIImage, text: String, button: String) {
        self.image = image
        self.text = text
        self.button = button
    }
}

public protocol SoldViewDelegate: NSObjectProtocol {
    func soldView(_ soldView: SoldView, didSelectCallToAction: Button)
}

public class SoldView: UIView {

    // MARK: - Public properties

    public weak var delegate: SoldViewDelegate?

    // MARK: - Internal properties

    let viewModel: SoldViewModel

    // MARK: - UI properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .btnPrimary
        return imageView
    }()

    private lazy var title: Label = {
        let label = Label(style: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var button: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(callToActionButtonTapped(button:)), for: .touchUpInside)
        return button
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
                imageView,
                title,
                button
            ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 24
        stack.alignment = .center
        stack.axis = .vertical
        return stack
    }()

    // MARK: - Init

    public init(viewModel: SoldViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        imageView.image = viewModel.image
        title.text = viewModel.text
        button.setTitle(viewModel.button, for: .normal)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 250)
        ])
    }

    // MARK: - Private methods

    @objc private func callToActionButtonTapped(button: Button) {
        delegate?.soldView(self, didSelectCallToAction: button)
    }
}
