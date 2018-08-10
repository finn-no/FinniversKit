//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class RibbonDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testRibbonDemoView() {
        let controller = ViewController<RibbonDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

}
