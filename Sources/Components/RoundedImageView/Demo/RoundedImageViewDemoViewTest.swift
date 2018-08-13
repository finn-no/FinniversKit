//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class RoundedImageViewDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testRoundedImageViewDemoView() {
        let controller = ViewController<RoundedImageViewDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

}
