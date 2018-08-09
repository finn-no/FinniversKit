//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class RadioButtonDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testRadioButtonDemoView() {
        let controller = ViewController<RadioButtonDemoView>()
        FBSnapshotVerifyView(controller.view)
    }
}
