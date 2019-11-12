import UIKit
@testable import Demo
import Sparkle

class TestConfig: NSObject {
    static var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    override init() {
        SparkleState.setCurrentUserInterfaceStyle(.light, in: TestConfig.appDelegate?.window)
    }
}
