//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
@testable import FinniversKit

class SnapshotTests: FBSnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        recordMode = true
    }
    
    func testExample() {
        let label = Label(frame: CGRect(x: 0, y: 0, width: 250, height: 44))
        label.font = .title2
        label.text = "Snapshot Test"
        FBSnapshotVerifyView(label)
        FBSnapshotVerifyLayer(label.layer)
    }
}
