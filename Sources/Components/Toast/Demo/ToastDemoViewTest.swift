//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class ToastDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testToastDemoView() {
        let controller = ViewController<ToastDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

}
