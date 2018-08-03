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
        let label = Label(style: .title2)
        label.text = "Snapshot Testing"
        FBSnapshotVerifyView(label)
        FBSnapshotVerifyLayer(label.layer)
    }
}
