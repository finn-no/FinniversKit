//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class ButtonDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testButtonDemoView() {
        let controller = ViewController<ButtonDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

}
