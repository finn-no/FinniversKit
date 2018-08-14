//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import Demo

extension DnaViewTests {
    func snapshot(_ component: DnaViews) {
        FBSnapshotVerifyView(component.viewController.view)
    }
}

extension ComponentViewTests {
    func snapshot(_ component: ComponentViews) {
        FBSnapshotVerifyView(component.viewController.view)
    }
}

extension RecyclingViewTests {
    func snapshot(_ component: RecyclingViews) {
        FBSnapshotVerifyView(component.viewController.view)
    }
}

extension FullscreenViewTests {
    func snapshot(_ component: FullscreenViews) {
        FBSnapshotVerifyView(component.viewController.view)
    }
}
