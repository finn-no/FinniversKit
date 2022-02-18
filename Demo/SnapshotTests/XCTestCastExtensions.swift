//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import XCTest
import SnapshotTesting
import Foundation

extension XCTestCase {
    func assertSnapshots(
        matching viewController: UIViewController,
        includeDarkMode: Bool = true,
        includeIPad: Bool = false,
        delay: TimeInterval? = nil,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        let subpixelThreshold: UInt8 = 5
        var snapshotting: Snapshotting = .image(on: .iPhoneX, subpixelThreshold: subpixelThreshold)
        if let delay = delay {
            snapshotting = .wait(for: delay, on: snapshotting)
        }

        let iPhoneSnapshotViewController = SnapshotWrapperViewController(demoViewController: viewController)
        assertSnapshot(
            matching: iPhoneSnapshotViewController, as: snapshotting, named: "iPhone",
            record: recording, file: file, testName: testName, line: line
        )

        if includeIPad {
            var snapshotting: Snapshotting = .image(on: .iPadPro11, subpixelThreshold: subpixelThreshold)
            if let delay = delay {
                snapshotting = .wait(for: delay, on: snapshotting)
            }

            let iPadSnapshotViewController = IPadSnapshotWrapperViewController(demoViewController: viewController)
            assertSnapshot(
                matching: iPadSnapshotViewController, as: snapshotting, named: "iPad",
                record: recording, file: file, testName: testName, line: line
            )
        }
    }

    func elementWithoutTests<T>(
        for caseIterable: T.Type,
        testMethodPrefix: String = "test"
    ) -> [T] where T: CaseIterable, T: RawRepresentable, T.RawValue == String {
        let testMethodPrefix = testMethodPrefix.lowercased()
        var methodCount: UInt32 = 0

        guard let methodList = class_copyMethodList(type(of: self), &methodCount) else {
            return []
        }

        let testMethods = (0..<Int(methodCount))
            .map({ index -> String in
                let selName = sel_getName(method_getName(methodList[index]))
                return String(cString: selName, encoding: .utf8)!.lowercased()
            })
            .filter({ $0.starts(with: testMethodPrefix) })

        return caseIterable.allCases.filter({
            !testMethods.contains("\(testMethodPrefix)\($0.rawValue)".lowercased())
        })
    }
}
