//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public class MotorTransactionInvalidUserDemoView: UIView {
    private lazy var motorTransactionInvalidUserView: MotorTransactionInvalidUserView = {
        let view = MotorTransactionInvalidUserView()
        view.delegate = self
        view.configure(MotorTransactionInvalidUserViewModel.defaultData)
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
        addSubview(motorTransactionInvalidUserView)
        motorTransactionInvalidUserView.fillInSuperview()
    }
}

extension MotorTransactionInvalidUserDemoView: MotorTransactionInvalidUserViewDelegate {
    public func didTapContinueButton(_ button: Button) {
        print("MotorTransactionInvalidUserDemoView: Did tap continue button")
    }

    public func didTapCancelButton(_ button: Button) {
        print("MotorTransactionInvalidUserDemoView: Did tap cancel button")
    }
}

public extension MotorTransactionInvalidUserViewModel {
    static var defaultData = MotorTransactionInvalidUserViewModel(
        title: "Du er logget inn med en annen konto enn den du har opprettet kontrakten med.",
        detail: NSAttributedString(string: "Logg inn med selger@mail.no for å invitere en kjøper til kontrakten."),
        continueButtonText: "Fortsett",
        cancelButtonText: "Avbryt"
    )
}
