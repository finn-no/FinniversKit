//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - SaveSearchPromptViewDelegate

public protocol SaveSearchPromptViewDelegate: AnyObject {
    func saveSearchPromptView(_ saveSearchPromptView: SaveSearchPromptView, didAcceptSaveSearch: Bool)
}

// MARK: - SaveSearchPromptView

public class SaveSearchPromptView: UIView {

    public enum State {
        case initial
        case accept
        case finished
    }

    // MARK: - Public properties

    public weak var delegate: SaveSearchPromptViewDelegate?

    // MARK: - Private properties

    private var state: State = .initial

    private lazy var title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.font = .captionStrong
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var positiveButton: UIButton = {
        let button = Button(style: .utility, size: .small)
        button.addTarget(self, action: #selector(positiveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: .remove), for: .normal)
        button.tintColor = .stone
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .marble

        addSubview(title)
        addSubview(positiveButton)
        addSubview(dismissButton)

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing*3),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            positiveButton.topAnchor.constraint(equalTo: title.bottomAnchor, constant: .mediumLargeSpacing),
            positiveButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: .smallSpacing),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.smallSpacing),
            dismissButton.widthAnchor.constraint(equalToConstant: 28),
            dismissButton.heightAnchor.constraint(equalToConstant: 28),
        ])
    }

    // MARK: - Public methods

    public func setState(_ state: State, withViewModel viewModel: SaveSearchPromptViewModel? = nil) {
        self.state = state

        if state == .finished {
            isHidden = true
            return
        }

        guard let viewModel = viewModel else { return }
        configure(withViewModel: viewModel)
    }

    // MARK: - Private methods

    private func configure(withViewModel viewModel: SaveSearchPromptViewModel) {
        title.text = viewModel.title
        if let buttonTitle = viewModel.positiveButtonTitle {
            positiveButton.setTitle(buttonTitle, for: .normal)
        } else {
            positiveButton.isHidden = true
        }
        setNeedsLayout()
    }

    @objc private func positiveButtonTapped() {
        delegate?.saveSearchPromptView(self, didAcceptSaveSearch: true)
    }

    @objc private func dismissButtonTapped() {
        delegate?.saveSearchPromptView(self, didAcceptSaveSearch: false)
    }
}
