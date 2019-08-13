import UIKit

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

    public static func setCurrentUserInterfaceStyle(_ userInterfaceStyle: UserInterfaceStyle) {
        UserDefaults.standard.set(userInterfaceStyle.rawValue, forKey: currentUserInterfaceStyleKey)
        UserDefaults.standard.synchronize()
    }
}
