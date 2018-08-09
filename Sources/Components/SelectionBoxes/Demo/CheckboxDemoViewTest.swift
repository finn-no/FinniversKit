//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class CheckboxDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testCheckboxDemoView() {
        let controller = ViewController<CheckboxDemoView>()
        FBSnapshotVerifyView(controller.view)
    }
}
