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
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertSnapshot(
            matching: viewController, as: .image(on: .iPhoneX), named: "iPhone",
            file: file, testName: testName, line: line
        )

        if includeDarkMode {
            assertSnapshot(
                matching: viewController, as: .image(on: .iPhoneX(.portrait, .dark)), named: "iPhone-Dark",
                file: file, testName: testName, line: line
            )
        }

        if includeIPad {
            assertSnapshot(
                matching: viewController, as: .image(on: .iPadPro11), named: "iPad",
                file: file, testName: testName, line: line
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
