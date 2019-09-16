import UIKit
@testable import Demo

class TestConfig: NSObject {
    static var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    override init() {
        State.setCurrentUserInterfaceStyle(.light, in: TestConfig.appDelegate?.window)
    }
}
