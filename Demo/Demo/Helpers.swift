//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

extension String {
    var capitalizingFirstLetter: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

struct State {
    private static let lastSelectedIndexPathRowKey = "lastSelectedIndexPathRowKey"
    private static let lastSelectedIndexPathSectionKey = "lastSelectedIndexPathSectionKey"
    private static let lastCornerForTweakingButtonKey = "lastCornerForTweakingButtonKey"
    private static let lastSelectedSectionKey = "lastSelectedSectionKey"
    private static let currentUserInterfaceStyleKey = "currentUserInterfaceStyleKey"

    static var lastSelectedIndexPath: IndexPath? {
        get {
            guard let row = UserDefaults.standard.object(forKey: lastSelectedIndexPathRowKey) as? Int else { return nil }
            guard let section = UserDefaults.standard.object(forKey: lastSelectedIndexPathSectionKey) as? Int else { return nil }
            return IndexPath(row: row, section: section)
        }
        set {
            if let row = newValue?.row {
                UserDefaults.standard.set(row, forKey: lastSelectedIndexPathRowKey)
            } else {
                UserDefaults.standard.removeObject(forKey: lastSelectedIndexPathRowKey)
            }

            if let section = newValue?.section {
                UserDefaults.standard.set(section, forKey: lastSelectedIndexPathSectionKey)
            } else {
                UserDefaults.standard.removeObject(forKey: lastSelectedIndexPathSectionKey)
            }
            UserDefaults.standard.synchronize()
        }
    }

    private static let shouldShowDismissInstructionsKey = "shouldShowDismissInstructions"

    static var shouldShowDismissInstructions: Bool {
        get {
            return UserDefaults.standard.object(forKey: shouldShowDismissInstructionsKey) as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: shouldShowDismissInstructionsKey)
            UserDefaults.standard.synchronize()
        }
    }

    static var lastCornerForTweakingButton: Int? {
        get {
            return UserDefaults.standard.object(forKey: lastCornerForTweakingButtonKey) as? Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lastCornerForTweakingButtonKey)
            UserDefaults.standard.synchronize()
        }
    }

    static var lastSelectedSection: Int {
        get {
            return UserDefaults.standard.object(forKey: lastSelectedSectionKey) as? Int ?? 0
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lastSelectedSectionKey)
            UserDefaults.standard.synchronize()
        }
    }

    static var currentUserInterfaceStyle: UserInterfaceStyle {
        get {
            let styleRawValue = UserDefaults.standard.object(forKey: currentUserInterfaceStyleKey) as? Int ?? 0
            return UserInterfaceStyle(rawValue: styleRawValue) ?? .light
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: currentUserInterfaceStyleKey)
            UserDefaults.standard.synchronize()
        }
    }
}
