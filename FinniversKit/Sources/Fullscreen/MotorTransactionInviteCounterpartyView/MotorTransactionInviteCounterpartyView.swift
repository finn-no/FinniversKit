//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol MotorTransactionInviteCounterpartyViewDelegate: AnyObject {
    func motorTransactionInviteCounterpartyView(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView,
        didSelect profile: BuyerPickerProfileModel,
        forRowAt indexPath: IndexPath
    )

    func motorTransactionInviteCounterpartyViewDidSelectFallbackCell(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView
    )

    func motorTransactionInviteCounterpartyView(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView,
        loadImageForModel model: BuyerPickerProfileModel,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    )

    func motorTransactionInviteCounterpartyView(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView,
        cancelLoadingImageForModel model: BuyerPickerProfileModel,
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

    public func configure(_ viewModel: BuyerPickerViewModel, selectLaterButtonText: String) {
        pickABuyerView.model = viewModel
        pickLaterButton.setTitle(selectLaterButtonText, for: .normal)
    }

    private func setup() {
        addSubview(pickABuyerView)
        addSubview(pickLaterButton)

        NSLayoutConstraint.activate([
            pickABuyerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingXL),
            pickABuyerView.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            pickABuyerView.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            pickABuyerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor, constant: 96),

            pickLaterButton.topAnchor.constraint(equalTo: pickABuyerView.bottomAnchor, constant: .spacingL),
            pickLaterButton.leadingAnchor.constraint(equalTo: pickABuyerView.leadingAnchor),
            pickLaterButton.trailingAnchor.constraint(equalTo: pickABuyerView.trailingAnchor),
        ])

    }

    @objc private func didTapPickLaterButton() {
        delegate?.motorTransactionInviteCounterpartyViewDidTapPickLaterButton(self)
    }
}

extension MotorTransactionInviteCounterpartyView: BuyerPickerViewDelegate {
    public func buyerPickerView(
        _ buyerPickerView: BuyerPickerView,
        didSelect profile: BuyerPickerProfileModel,
        forRowAt indexPath: IndexPath
    ) {
        delegate?.motorTransactionInviteCounterpartyView(self, didSelect: profile, forRowAt: indexPath)
    }

    public func buyerPickerViewDidSelectFallbackCell(
        _ buyerPickerView: BuyerPickerView
    ) {
        delegate?.motorTransactionInviteCounterpartyViewDidSelectFallbackCell(self)
    }

    public func buyerPickerView(
        _ buyerPickerView: BuyerPickerView,
        loadImageForModel model: BuyerPickerProfileModel,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        delegate?.motorTransactionInviteCounterpartyView(
            self,
            loadImageForModel: model,
            imageWidth: imageWidth,
            completion: completion
        )
    }

    public func buyerPickerView(
        _ buyerPickerView: BuyerPickerView,
        cancelLoadingImageForModel model: BuyerPickerProfileModel,
        imageWidth: CGFloat
    ) {
        delegate?.motorTransactionInviteCounterpartyView(
            self,
            cancelLoadingImageForModel: model,
            imageWidth: imageWidth
        )
    }

    public func buyerPickerViewCenterTitleInHeaderView(
        _ buyerPickerView: BuyerPickerView,
        viewForHeaderInSection section: Int
    ) -> Bool {
        return true
    }
}
