//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class InlineConsentDemoViewTest: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testInlineConsentDemoView() {
        let controller = ViewController<InlineConsentDemoView>()
        FBSnapshotVerifyView(controller.view)
    }
    
}
