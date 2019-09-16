//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import FinniversKit

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
    static let currentUserInterfaceStyleKey = "currentUserInterfaceStyleKey"

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
            return UserDefaults.standard.integer(forKey: lastSelectedSectionKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lastSelectedSectionKey)
            UserDefaults.standard.synchronize()
        }
    }

    /// Needs to be called from main thread on iOS 13
    static func setCurrentUserInterfaceStyle(_ userInterfaceStyle: UserInterfaceStyle?, in window: UIWindow?) {
        if #available(iOS 13.0, *) {
            window?.setWindowUserInterfaceStyle(userInterfaceStyle)
        }
        if let userInterfaceStyle = userInterfaceStyle {
            UserDefaults.standard.set(userInterfaceStyle.rawValue, forKey: currentUserInterfaceStyleKey)
            FinniversKit.userInterfaceStyleSupport = userInterfaceStyle == .dark ? .forceDark : .forceLight
        } else {
            UserDefaults.standard.removeObject(forKey: currentUserInterfaceStyleKey)
            FinniversKit.userInterfaceStyleSupport = .forceLight
        }
        UserDefaults.standard.synchronize()
    }

    static func currentUserInterfaceStyle(for traitCollection: UITraitCollection) -> UserInterfaceStyle {
        if #available(iOS 13.0, *) {
            return traitCollection.userInterfaceStyle == .dark ? .dark : .light
        } else {
            let styleRawValue = UserDefaults.standard.integer(forKey: currentUserInterfaceStyleKey)
            return UserInterfaceStyle(rawValue: styleRawValue) ?? .light
        }
    }
}

extension UIWindow {
    @available(iOS 13.0, *)
    func setWindowUserInterfaceStyle(_ userInterfaceStyle: UserInterfaceStyle?) {
        #if swift(>=5.1)
        let uiUserInterfaceStyle: UIUserInterfaceStyle
        if let userInterfaceStyle = userInterfaceStyle {
            uiUserInterfaceStyle = userInterfaceStyle == .dark ? .dark : .light
        } else {
            uiUserInterfaceStyle = .unspecified
        }
        overrideUserInterfaceStyle = uiUserInterfaceStyle
        #endif
    }
}
