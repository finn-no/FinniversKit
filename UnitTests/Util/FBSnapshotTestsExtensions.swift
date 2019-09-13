//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import FBSnapshotTestCase
import Foundation

extension FBSnapshotTestCase {
    func assertMissingTests<T>(for caseIterable: T.Type) where T: CaseIterable, T: RawRepresentable, T.RawValue == String {
        var methodCount: UInt32 = 0

        guard let methodList = class_copyMethodList(type(of: self), &methodCount) else {
            XCTFail("Cannot copy method list to assert missing tests")
            return
        }

        let testMethods = (0..<Int(methodCount))
            .map({ index -> String in
                let selName = sel_getName(method_getName(methodList[index]))
                return String(cString: selName, encoding: .utf8)!.lowercased()
            })
            .filter({ $0.starts(with: "test") })

        for element in caseIterable.allCases {
            if !testMethods.contains("test\(element.rawValue)".lowercased()) {
                XCTFail("Not all elements were implemented, missing: \(element.rawValue)")
            }
        }
    }
}
