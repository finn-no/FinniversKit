//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class TextFieldDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testTextFieldDemoView() {
        let controller = ViewController<TextFieldDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

}
