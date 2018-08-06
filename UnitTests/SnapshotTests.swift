//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
@testable import FinniversKit
@testable import Demo

class SnapshotTests: FBSnapshotTestCase {
    
    // For these tests to work, first create a reference image by running the tests with recordMode = true.
    // The reference image should display the wanted look of the views.
    // Setting recordMode = false will then compare the referance image to the current views and fail the test if they are different.
    // Referance images are saved to ../UnitTests/ReferenceImages and the failed test images are saved to ../UnitTests/FailureDiffs
    
    override func setUp() {
        super.setUp()
        recordMode = false
    }
    
    // Images have the same name as the method name
    func testExampleLabel() {
        isDeviceAgnostic = false
        
        // Views need a frame, intrinsic size is not supported
        let label = Label(frame: CGRect(x: 0, y: 0, width: 250, height: 44))
        label.font = .title2
        label.text = "Snapshot Test"
        FBSnapshotVerifyView(label)
        FBSnapshotVerifyLayer(label.layer)
    }
    
    func testExampleControllerView() {
        // Appends device (iPhone, iPad), iOS version and frame size to image name
        isDeviceAgnostic = true
        
        let controller = ViewController<LoginViewDemoView>()
        FBSnapshotVerifyView(controller.view)
        FBSnapshotVerifyLayer(controller.view.layer)
    }
    
}
