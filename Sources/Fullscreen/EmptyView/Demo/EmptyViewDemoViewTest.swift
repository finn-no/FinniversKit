//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class EmptyViewDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testEmptyViewDemoView() {
        let controller = ViewController<EmptyViewDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

}

