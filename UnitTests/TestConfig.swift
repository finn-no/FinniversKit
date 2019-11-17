import UIKit
@testable import Demo
import Sandbox

class TestConfig: NSObject {
    static var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    override init() {
        SandboxState.setCurrentUserInterfaceStyle(.light, in: TestConfig.appDelegate?.window)
    }
}
