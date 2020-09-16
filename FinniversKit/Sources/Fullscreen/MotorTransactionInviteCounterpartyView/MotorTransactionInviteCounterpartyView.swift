//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public protocol MotorTransactionInviteCounterpartyViewDelegate: AnyObject {
    func motorTransactionInviteCounterpartyView(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView,
        didSelect profile: MotorTransactionInviteCounterpartyProfileViewModel
    )

    func motorTransactionInviteCounterpartyViewPlaceholderImage(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView
    ) -> UIImage?

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
}

// swiftlint:disable: type_name
public class MotorTransactionInviteCounterpartyView: UIView {
    private lazy var pickABuyerView: BuyerPickerView = {
        let view = BuyerPickerView(withAutoLayout: true)
        view.delegate = self
        return view
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
    }

    private func setup() {
        addSubview(pickABuyerView)
        pickABuyerView.fillInSuperview()
    }
}

extension MotorTransactionInviteCounterpartyView: BuyerPickerViewDelegate {
    public func buyerPickerView(
        _ buyerPickerView: BuyerPickerView,
        didSelect profile: BuyerPickerProfileModel
    ) {
        guard let counterpartyProfile = profile as? MotorTransactionInviteCounterpartyProfileViewModel else { return }
        delegate?.motorTransactionInviteCounterpartyView(self, didSelect: counterpartyProfile)
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
        guard let counterpartyProfile = model as? MotorTransactionInviteCounterpartyProfileViewModel else { return }
        delegate?.motorTransactionInviteCounterpartyView(
            self,
            loadImageForModel: counterpartyProfile,
            imageWidth: imageWidth,
            completion: completion
        )
    }

    public func buyerPickerView(
        _ buyerPickerView: BuyerPickerView,
        cancelLoadingImageForModel model: BuyerPickerProfileModel,
        imageWidth: CGFloat
    ) {
        guard let counterpartyProfile = model as? MotorTransactionInviteCounterpartyProfileViewModel else { return }
        delegate?.motorTransactionInviteCounterpartyView(
            self,
            cancelLoadingImageForModel: counterpartyProfile,
            imageWidth: imageWidth
        )
    }
}
