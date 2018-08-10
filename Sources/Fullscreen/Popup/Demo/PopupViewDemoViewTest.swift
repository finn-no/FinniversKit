//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class PopupViewDemoViewTest: FBSnapshotTestCase {

        override func setUp() {
            super.setUp()
            recordMode = false
        }

        func testPopupViewDemoView() {
            let controller = ViewController<PopupViewDemoView>()
            FBSnapshotVerifyView(controller.view)
        }

}

