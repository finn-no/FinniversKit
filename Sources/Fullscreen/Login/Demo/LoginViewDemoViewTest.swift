//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class LoginViewDemoViewTest: FBSnapshotTestCase {
    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testExampleControllerView() {
        let controller = ViewController<LoginViewDemoView>()
        FBSnapshotVerifyView(controller.view)
    }
}
