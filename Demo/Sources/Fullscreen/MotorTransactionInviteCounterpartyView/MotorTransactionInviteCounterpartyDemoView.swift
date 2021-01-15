//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

// swiftlint:disable:next type_name
public class MotorTransactionInviteCounterpartyDemoView: UIView {
    private lazy var inviteCounterpartyView: MotorTransactionInviteCounterpartyView = {
        let view = MotorTransactionInviteCounterpartyView(withAutoLayout: true)
        view.delegate = self
        view.configure(BuyerPickerDemoData(), selectLaterButtonText: "Inviter senere")
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(inviteCounterpartyView)
        inviteCounterpartyView.fillInSuperview()
    }
}

extension MotorTransactionInviteCounterpartyDemoView: MotorTransactionInviteCounterpartyViewDelegate {
    public func motorTransactionInviteCounterpartyView(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView,
        didSelect profile: BuyerPickerProfileModel,
        forRowAt indexPath: IndexPath
    ) {
        LoadingView.show(afterDelay: 0)

        print("Did select: \(profile.name) for review")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            LoadingView.hide()
        })
    }

    public func motorTransactionInviteCounterpartyViewDidSelectFallbackCell(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView
    ) {}

    public func motorTransactionInviteCounterpartyView(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView,
        loadImageForModel model: BuyerPickerProfileModel,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        guard let url = model.image else {
            let defaultImage = UIImage(named: .consentTransparencyImage)
            completion(defaultImage)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }

        task.resume()
    }

    public func motorTransactionInviteCounterpartyView(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView,
        cancelLoadingImageForModel model: BuyerPickerProfileModel,
        imageWidth: CGFloat
    ) {}

    public func motorTransactionInviteCounterpartyViewDidTapPickLaterButton(_ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView) {
        print("Did tap pick later button")
    }
}
