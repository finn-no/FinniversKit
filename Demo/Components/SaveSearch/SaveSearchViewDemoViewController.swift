//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import Sandbox

struct SampleSaveSearchViewModel: SaveSearchViewModel {
    let searchPlaceholderText: String = "Navn på søk"
    let pushTitle: String = "Push-varsling"
    let pushDetail: String = "Motta push-varsel når nye annonser legges ut"
    let pushIsOn: Bool = true
    let emailTitle: String = "E-post varsling"
    let emailDetail: String = "Motta e-post når nye annonser legges ut"
    let emailIsOn: Bool = true
}

class SaveSearchViewDemoViewController: BaseDemoViewController<UIView> {
    private lazy var saveSearchView = SaveSearchView(withAutoLayout: true)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Lagre søk"

        saveSearchView.configure(with: SampleSaveSearchViewModel())

        view.addSubview(saveSearchView)
        saveSearchView.fillInSuperview()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        saveSearchView.becomeFirstResponder()
    }
}
