////
////  Copyright © FINN.no AS, Inc. All rights reserved.
////
//
//import UIKit
//import FinniversKit
//
//public extension UIImage {
//
//    /// Convenience method to create dynamic images for dark mode if the OS supports it (independant of FinniversKit
//    /// settings)
//    /// - Parameters:
//    ///   - defaultImage: light mode version of the Image
//    ///   - darkModeImage: dark mode version of the Image
//    class func dynamicImage(defaultImage: UIImage, darkModeImage: UIImage) -> UIImage {
//        if #available(iOS 13.0, *) {
//            #if swift(>=5.1)
//            return UIImage { traitCollection -> UIImage in
//                switch traitCollection.userInterfaceStyle {
//                case .dark:
//                    return darkModeImage
//                default:
//                    return defaultImage
//                }
//            }
//            #endif
//        }
//        return defaultImage
//    }
//
//    /// Convenience mehtod to create dynamic Images **considering FinniversKit settings** and if the OS supports it
//    /// - Parameters:
//    ///   - defaultColor: light mode version of the color
//    ///   - darkModeColor: dark mode version of the color
//    class func dynamicImageIfAvailable(defaultImage: UIImage, darkModeImage: UIImage) -> UIImage {
//        switch FinniversKit.userInterfaceStyleSupport {
//        case .forceDark:
//            return darkModeImage
//        case .forceLight:
//            return defaultImage
//        case .dynamic:
//            return dynamicImage(defaultImage: defaultImage, darkModeImage: darkModeImage)
//        }
//    }
//
//}
