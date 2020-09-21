//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

// swiftlint:disable:next type_name
public class MotorTransactionInviteCounterpartyDemoView: UIView {
    private lazy var inviteCounterpartyView: MotorTransactionInviteCounterpartyView = {
        let view = MotorTransactionInviteCounterpartyView(withAutoLayout: true)
        view.delegate = self
        view.configure(MotorTransactionInviteCounterpartyViewModel.defaultData)
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
        didSelect profile: MotorTransactionInviteCounterpartyProfileViewModel
    ) {
        LoadingView.show(afterDelay: 0)

        print("Did select: \(profile.name) for review")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            LoadingView.hide()
        })
    }

    public func motorTransactionInviteCounterpartyViewPlaceholderImage(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView
    ) -> UIImage? {
        return nil
    }

    public func motorTransactionInviteCounterpartyView(
        _ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView,
        loadImageForModel model: MotorTransactionInviteCounterpartyProfileViewModel,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        guard let url = model.image else {
            completion(nil)
            return
        }

        // Demo code only.
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
        cancelLoadingImageForModel model: MotorTransactionInviteCounterpartyProfileViewModel,
        imageWidth: CGFloat
    ) {}

    public func motorTransactionInviteCounterpartyViewDidTapPickLaterButton(_ motorTransactionInviteCounterpartyView: MotorTransactionInviteCounterpartyView) {
        print("Did tap pick later button")
    }
}

public extension MotorTransactionInviteCounterpartyViewModel {
    static var defaultData: MotorTransactionInviteCounterpartyViewModel {
        return MotorTransactionInviteCounterpartyViewModel(
            title: "Velg den du gjorde handelen med:",
            profiles: [
                BuyerPickerDemoUser(name: "Ola Nordmann", image: URL(string: "http://via.placeholder.com/44x44/111111/111111")),
                BuyerPickerDemoUser(name: "Per Johansen", image: URL(string: "http://via.placeholder.com/44x44/ff00ff/ff00ff")),
                BuyerPickerDemoUser(name: "Per"),
                BuyerPickerDemoUser(name: "FINN Bruker"),
                BuyerPickerDemoUser(name: "Test testesen", image: URL(string: "http://via.placeholder.com/44x44/ffff00/ffff00")),
                BuyerPickerDemoUser(name: "E-post eller mobilnummer")
            ],
            selectTitle: "Velg",
            confirmationTitle: "Du kan ikke endre valget ditt senere"
        )
    }
}
