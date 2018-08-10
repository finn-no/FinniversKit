//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class BroadcastDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testBroadcastDemoView() {
        let controller = ViewController<BroadcastDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

}
