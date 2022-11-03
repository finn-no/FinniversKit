import Foundation
import SwiftUI
import UIKit

extension Font.Weight {
    init(_ weight: UIFont.Weight) {
        switch weight {
        case .black: self = .black
        case .bold: self = .bold
        case .heavy: self = .heavy
        case .light: self = .light
        case .medium: self = .medium
        case .regular: self = .regular
        case .semibold: self = .semibold
        case .thin: self = .thin
        case .ultraLight: self = .ultraLight
        default: self = .regular
        }
    }
}
