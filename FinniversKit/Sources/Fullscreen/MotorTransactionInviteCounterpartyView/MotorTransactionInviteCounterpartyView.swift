//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol MotorTransactionInviteCounterpartyViewDelegate: AnyObject {
    func motorTransactionInviteCounterpartyView(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView,
        didSelect profile: MotorTransactionInviteCounterpartyProfileViewModel
    )

    func motorTransactionInviteCounterpartyView(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView,
        loadImageForModel model: MotorTransactionInviteCounterpartyProfileViewModel,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    )

    func motorTransactionInviteCounterpartyView(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView,
        cancelLoadingImageForModel model: MotorTransactionInviteCounterpartyProfileViewModel,
        imageWidth: CGFloat
    )

    func motorTransactionInviteCounterpartyViewDidTapPickLaterButton(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView
    )
}

// swiftlint:disable: type_name
public class MotorTransactionInviteCounterpartyView: UIView {
    private lazy var pickABuyerView: BuyerPickerView = {
        let view = BuyerPickerView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var pickLaterButton: Button = {
        let button = Button(style: .flat, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(didTapPickLaterButton), for: .touchUpInside)
        return button
    }()

    public weak var delegate: MotorTransactionInviteCounterpartyViewDelegate?

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(_ viewModel: MotorTransactionInviteCounterpartyViewModel) {
        pickABuyerView.model = viewModel
        pickLaterButton.setTitle(viewModel.selectLaterButtonText, for: .normal)
    }

    private func setup() {
        addSubview(pickABuyerView)
        addSubview(pickLaterButton)

        NSLayoutConstraint.activate([
            pickABuyerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            pickABuyerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            pickABuyerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            pickABuyerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: .spacingXXL),

            pickLaterButton.topAnchor.constraint(equalTo: pickABuyerView.bottomAnchor),
            pickLaterButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingL),
            pickLaterButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingL),
        ])

    }

    @objc private func didTapPickLaterButton() {
        delegate?.motorTransactionInviteCounterpartyViewDidTapPickLaterButton(self)
    }
}

extension MotorTransactionInviteCounterpartyView: BuyerPickerViewDelegate {
    public func buyerPickerView(
        _ buyerPickerView: BuyerPickerView,
        didSelect profile: BuyerPickerProfileModel
    ) {
        let counterPartyProfile = MotorTransactionInviteCounterpartyProfileViewModel(name: profile.name, image: profile.image)
        delegate?.motorTransactionInviteCounterpartyView(self, didSelect: counterPartyProfile)
    }

    public func buyerPickerViewDefaultPlaceholderImage(_ buyerPickerView: BuyerPickerView) -> UIImage? {
        return delegate?.motorTransactionInviteCounterpartyViewPlaceholderImage(self)
    }

    public func buyerPickerView(
        _ buyerPickerView: BuyerPickerView,
        loadImageForModel model: BuyerPickerProfileModel,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        let counterPartyProfile = MotorTransactionInviteCounterpartyProfileViewModel(name: model.name, image: model.image)
        delegate?.motorTransactionInviteCounterpartyView(
            self,
            loadImageForModel: counterPartyProfile,
            imageWidth: imageWidth,
            completion: completion
        )
    }

    public func buyerPickerView(
        _ buyerPickerView: BuyerPickerView,
        cancelLoadingImageForModel model: BuyerPickerProfileModel,
        imageWidth: CGFloat
    ) {
        let counterPartyProfile = MotorTransactionInviteCounterpartyProfileViewModel(name: model.name, image: model.image)
        delegate?.motorTransactionInviteCounterpartyView(
            self,
            cancelLoadingImageForModel: counterPartyProfile,
            imageWidth: imageWidth
        )
    }
}
