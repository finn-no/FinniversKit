//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import XCTest
import Foundation

extension XCTestCase {
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
