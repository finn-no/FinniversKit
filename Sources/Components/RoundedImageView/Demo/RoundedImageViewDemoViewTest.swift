//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import FinniversKit
import Demo

class RoundedImageViewDemoViewTest: FBSnapshotTestCase {

    override func setUp() {
        super.setUp()
        recordMode = true
    }

    func testRoundedImageViewDemoView() {
        let imageView = RoundedImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = UIImage(named: "AppIcon")
        FBSnapshotVerifyView(imageView)
    }

}
