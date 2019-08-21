//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

struct SampleSaveSearchViewModel: SaveSearchViewModel {
    let searchPlaceholderText: String = "Navn på søk"
    let pushTitle: String = "Push-varsling"
    let pushDetail: String = "Motta push-varsel når nye annonser legges ut"
    let pushIsOn: Bool = true
    let emailTitle: String = "E-post varsling"
    let emailDetail: String = "Motta e-post når nye annonser legges ut"
    let emailIsOn: Bool = true
}

class SaveSearchViewDemoView: UIView {
    private lazy var saveSearchView = SaveSearchView(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        saveSearchView.configure(with: SampleSaveSearchViewModel())

        addSubview(saveSearchView)
        saveSearchView.fillInSuperview()
    }
}
