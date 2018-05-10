//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

extension String {
    var capitalizingFirstLetter: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

extension IndexPath {
    private static let lastSelectedRowKey = "lastSelectedRowKey"
    private static let lastSelectedSectionKey = "lastSelectedSectionKey"

    static var lastSelected: IndexPath? {
        get {
            guard let row = UserDefaults.standard.object(forKey: lastSelectedRowKey) as? Int else { return nil }
            guard let section = UserDefaults.standard.object(forKey: lastSelectedSectionKey) as? Int else { return nil }
            return IndexPath(row: row, section: section)
        }
        set {
            if let row = newValue?.row {
                UserDefaults.standard.set(row, forKey: lastSelectedRowKey)
            } else {
                UserDefaults.standard.removeObject(forKey: lastSelectedRowKey)
            }

            if let section = newValue?.section {
                UserDefaults.standard.set(section, forKey: lastSelectedSectionKey)
            } else {
                UserDefaults.standard.removeObject(forKey: lastSelectedSectionKey)
            }
            UserDefaults.standard.synchronize()
        }
    }
}
