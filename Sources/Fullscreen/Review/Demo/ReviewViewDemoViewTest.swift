//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class ReviewViewDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testReviewViewDemoView() {
        let controller = ViewController<ReviewViewDemoView>()
        FBSnapshotVerifyView(controller.view)
    }

}

