//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class LabelDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testLabelDemoView() {
        let controller = ViewController<LabelDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

}
