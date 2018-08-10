//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class AdReporterDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testAdReporterDemoView() {
        let controller = ViewController<AdReporterDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

}
