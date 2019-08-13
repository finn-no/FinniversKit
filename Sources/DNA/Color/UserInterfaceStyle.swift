import UIKit

public class Theme {
    public static var currentStyle: UserInterfaceStyle = .light
}

@objc public enum UserInterfaceStyle: Int {
    private static let currentUserInterfaceStyleKey = "currentUserInterfaceStyleKey"

    case light
    case dark

    public init(traitCollection: UITraitCollection) {
        guard FinniversKit.isDarkModeSupported else {
            self = .light
            return
        }

        if #available(iOS 13.0, *) {
            self = traitCollection.userInterfaceStyle == .dark ? .dark : .light
        } else {
            let styleRawValue = UserDefaults.standard.integer(forKey: UserInterfaceStyle.currentUserInterfaceStyleKey)
            self = UserInterfaceStyle(rawValue: styleRawValue) ?? .light
        }
    }

    /// Needs to be called from main thread on iOS 13
    public static func setCurrentUserInterfaceStyle(_ userInterfaceStyle: UserInterfaceStyle) {
        if #available(iOS 13.0, *) {
            // Untested, this might change mode live (but not remember the setting)
            let uiUserInterfaceStyle: UIUserInterfaceStyle = userInterfaceStyle == .dark ? .dark : .light
            let updatedTraits = UITraitCollection(traitsFrom: [UITraitCollection.current, UITraitCollection(userInterfaceStyle: uiUserInterfaceStyle)])
            UITraitCollection.current = updatedTraits
        } else {
            UserDefaults.standard.set(userInterfaceStyle.rawValue, forKey: currentUserInterfaceStyleKey)
            UserDefaults.standard.synchronize()
        }
    }
}
