//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import FinnUI

class SaveSearchViewDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Creating a new search") { self.saveSearchView.configure(with: .createSavedSearch) },
        TweakingOption(title: "Editing an existing search") { self.saveSearchView.configure(with: .existingSavedSearch) },
    ]

    private lazy var saveSearchView = SaveSearchView(withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(saveSearchView)
        saveSearchView.fillInSuperview()
        tweakingOptions.first?.action?()
    }
}

// MARK: - Private types

private extension SwitchViewDefaultModel {
    static func notificationCenterViewModel(isOn: Bool) -> SwitchViewModel {
        SwitchViewDefaultModel(
            title: "FINN.no",
            detail: "Nye treff varsles umiddelbart under «Varslinger» på nettsiden og i appen",
            initialSwitchValue: isOn
        )
    }

    static func pushViewModel(isOn: Bool) -> SwitchViewModel {
        SwitchViewDefaultModel(
            title: "Push",
            detail: "Nye treff varsles umiddelbart på din mobil",
            initialSwitchValue: isOn
        )
    }

    static func emailViewModel(isOn: Bool) -> SwitchViewModel {
        SwitchViewDefaultModel(
            title: "E-post",
            detail: "Nye treff sendes daglig på e-post",
            initialSwitchValue: isOn
        )
    }
}

private extension SaveSearchViewModel {
    static var createSavedSearch = SaveSearchViewModel(
        searchTitle: "Grå sofa, Oslo",
        editNameButtonTitle: "Endre navn på søket",
        deleteSearchButtonTitle: nil,

        notificationCenterSwitchViewModel: SwitchViewDefaultModel.notificationCenterViewModel(isOn: true),
        pushSwitchViewModel: SwitchViewDefaultModel.pushViewModel(isOn: true),
        emailSwitchViewModel: SwitchViewDefaultModel.emailViewModel(isOn: true)
    )

    static var existingSavedSearch = SaveSearchViewModel(
        searchTitle: "Båtmotor, Torget, 1000-12000",
        editNameButtonTitle: "Endre navn på søket",
        deleteSearchButtonTitle: "Slett lagret søk",

        notificationCenterSwitchViewModel: SwitchViewDefaultModel.notificationCenterViewModel(isOn: true),
        pushSwitchViewModel: SwitchViewDefaultModel.pushViewModel(isOn: true),
        emailSwitchViewModel: SwitchViewDefaultModel.emailViewModel(isOn: true)
    )
}
