import Foundation
import XCTest
@testable import FinniversKit

private class OrphanMockView: UIView {
    override func convert(_ rect: CGRect, to view: UIView?) -> CGRect {
        return frame
    }
}

class KeyboardNotificationInfoTest: XCTestCase {
    private func createView(withFrame frame: CGRect) -> UIView {
        let view = OrphanMockView()
        view.frame = frame
        view.bounds = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        return view
    }

    private func rect(yPos: CGFloat, height: CGFloat) -> CGRect {
        return CGRect(x: 0, y: yPos, width: 1000, height: height)
    }

    private func createKeyboardInfo(frameEnd: CGRect) -> KeyboardNotificationInfo {
        let userInfo: [AnyHashable: Any] = [
            UIWindow.keyboardFrameEndUserInfoKey: frameEnd
        ]

        let notification = Notification(name: UIResponder.keyboardWillShowNotification, object: nil, userInfo: userInfo)
        guard let info = KeyboardNotificationInfo(notification) else {
            XCTFail("Failed to build KeyboardNotificationInfo")
            fatalError()
        }

        return info
    }

    func testKeyboardIntersectionZeroWhenNotOverlappingView() {
        let view = createView(withFrame: rect(yPos: 100, height: 400))
        let info = createKeyboardInfo(frameEnd: rect(yPos: 600, height: 400))

        let intersection = info.keyboardFrameEndIntersectHeight(inView: view)
        XCTAssertEqual(0, intersection)
    }

    func testKeyboardIntersectionNonZeroWhenOverlappingView() {
        let view = createView(withFrame: rect(yPos: 100, height: 600))
        let info = createKeyboardInfo(frameEnd: rect(yPos: 600, height: 400))

        let intersection = info.keyboardFrameEndIntersectHeight(inView: view)
        XCTAssertEqual(100, intersection)
    }

    func testKeyboardIntersectionWhenOutOfScreenBounds() {
        let view = createView(withFrame: rect(yPos: 0, height: 1500))
        let info = createKeyboardInfo(frameEnd: rect(yPos: 500, height: 500))

        let intersection = info.keyboardFrameEndIntersectHeight(inView: view)
        XCTAssertEqual(1000, intersection)
    }
}
