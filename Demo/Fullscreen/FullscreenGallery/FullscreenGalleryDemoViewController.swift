//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

class FullscreenGalleryDemoViewController: DemoViewController<FullscreenGalleryDemoView> {
    public override func viewDidLoad() {
        super.viewDidLoad()
        playgroundView.parentViewController = self
    }
}
