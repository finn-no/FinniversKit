import UIKit
import SparkleCommon

extension String {
    public var capitalizingFirstLetter: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

@objc public enum UserInterfaceStyle: Int {
    case light = 1
    case dark = 2

    public var image: UIImage {
        switch self {
        case .light:
            return UIImage(named: "emptyMoon")!
        case .dark:
            return UIImage(named: "filledMoon")!
        }
    }
}

public struct SparkleState {
    private static let lastSelectedIndexPathRowKey = "lastSelectedIndexPathRowKey"
    private static let lastSelectedIndexPathSectionKey = "lastSelectedIndexPathSectionKey"
    private static let lastCornerForTweakingButtonKey = "lastCornerForTweakingButtonKey"
    private static let lastSelectedSectionKey = "lastSelectedSectionKey"
    private static let lastSelectedDeviceKey = "lastSelectedDeviceKey"
    public static let currentUserInterfaceStyleKey = "currentUserInterfaceStyleKey"

    public static let defaultUserInterfaceStyleSupport: SparkleCommon.UserInterfaceStyleSupport = {
        if #available(iOS 13.0, *) {
            return .dynamic
        }
        return .forceLight
    }()

    public static var lastSelectedIndexPath: IndexPath? {
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

    public static var shouldShowDismissInstructions: Bool {
        get {
            // avoid dismiss instructions for test as it can interfere with snapshot tests
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
                return false
            }
            return UserDefaults.standard.object(forKey: shouldShowDismissInstructionsKey) as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: shouldShowDismissInstructionsKey)
            UserDefaults.standard.synchronize()
        }
    }

    public static var lastCornerForTweakingButton: Int? {
        get {
            return UserDefaults.standard.object(forKey: lastCornerForTweakingButtonKey) as? Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lastCornerForTweakingButtonKey)
            UserDefaults.standard.synchronize()
        }
    }

    public static var lastSelectedSection: Int {
        get {
            return UserDefaults.standard.integer(forKey: lastSelectedSectionKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lastSelectedSectionKey)
            UserDefaults.standard.synchronize()
        }
    }

    public static var lastSelectedDevice: Int? {
        get {
            return UserDefaults.standard.value(forKey: lastSelectedDeviceKey) as? Int
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lastSelectedDeviceKey)
            UserDefaults.standard.synchronize()
        }
    }

    /// Needs to be called from main thread on iOS 13
    public static func setCurrentUserInterfaceStyle(_ userInterfaceStyle: UserInterfaceStyle?, in window: UIWindow?) {
        if #available(iOS 13.0, *) {
            window?.setWindowUserInterfaceStyle(userInterfaceStyle)
        }
        if let userInterfaceStyle = userInterfaceStyle {
            UserDefaults.standard.set(userInterfaceStyle.rawValue, forKey: currentUserInterfaceStyleKey)
            SparkleCommon.userInterfaceStyleSupport = userInterfaceStyle == .dark ? .forceDark : .forceLight
        } else {
            UserDefaults.standard.removeObject(forKey: currentUserInterfaceStyleKey)
            SparkleCommon.userInterfaceStyleSupport = defaultUserInterfaceStyleSupport
        }
        UserDefaults.standard.synchronize()
    }

    public static func currentUserInterfaceStyle(for traitCollection: UITraitCollection) -> UserInterfaceStyle {
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
    public func setWindowUserInterfaceStyle(_ userInterfaceStyle: UserInterfaceStyle?) {
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
