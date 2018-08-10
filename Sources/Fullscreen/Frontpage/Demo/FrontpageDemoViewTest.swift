//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class FrontpageViewDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testFrontpageViewDemoView() {
        let controller = ViewController<FrontpageViewDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

}

