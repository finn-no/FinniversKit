//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class SaveSearchViewDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Creating a new search") { self.saveSearchView.configure(with: SampleSaveSearchViewModel()) },
        TweakingOption(title: "Editing an existing search") { self.saveSearchView.configure(with: SampleExistinSavedSearchViewModel()) }
    ]

    private lazy var saveSearchView = SaveSearchView(
        switchStyle: SwitchViewStyle(
            titleLabelStyle: .bodyStrong,
            titleLabelTextColor: .textPrimary,
            detailLabelStyle: .caption,
            detailLabelTextColor: .textPrimary
        ),
        withAutoLayout: true
    )

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
        saveSearchView.becomeFirstResponder()
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

private struct SampleSaveSearchViewModel: SaveSearchViewModel {
    let searchTitle: String? = nil
    let searchPlaceholderText = "Navn på søk"
    let deleteSearchButtonTitle: String? = nil

    let notificationCenterSwitchViewModel = SwitchViewDefaultModel.notificationCenterViewModel(isOn: true)
    let pushSwitchViewModel = SwitchViewDefaultModel.pushViewModel(isOn: true)
    let emailSwitchViewModel = SwitchViewDefaultModel.emailViewModel(isOn: true)
}

private struct SampleExistinSavedSearchViewModel: SaveSearchViewModel {
    let searchTitle: String? = "Båtmotor, Torget, 1000-12000"
    let searchPlaceholderText = "Navn på søk"
    let deleteSearchButtonTitle: String? = "Slett lagret søk"

    let notificationCenterSwitchViewModel = SwitchViewDefaultModel.notificationCenterViewModel(isOn: true)
    let pushSwitchViewModel = SwitchViewDefaultModel.pushViewModel(isOn: true)
    let emailSwitchViewModel = SwitchViewDefaultModel.emailViewModel(isOn: true)
}
