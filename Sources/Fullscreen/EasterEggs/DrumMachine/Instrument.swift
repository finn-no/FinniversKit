//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import AudioToolbox
import UIKit

enum Instrument: String {
    case kick = "Kick"
    case snare = "Snare"
    case hats = "Hi-Hats"
    case cat = "PuseFINN"

    var color: UIColor {
        switch self {
        case .kick:
            return .pea
        case .snare:
            return .yellow
        case .hats:
            return .watermelon
        case .cat:
            return .accentSecondaryBlue
        }
    }

    func play() {
        if let sound = sound {
            AudioServicesPlaySystemSound(sound)
        }

        if let haptics = haptics {
            AudioServicesPlaySystemSound(haptics)
        }
    }

    var sound: SystemSoundID? {
        let resource = rawValue.lowercased()
        let bundle = Bundle.finniversKit

        guard let soundURL = bundle.url(forResource: resource, withExtension: "wav") else {
            return nil
        }

        var sound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
        return sound
    }

    var haptics: SystemSoundID? {
        switch self {
        case .kick:
            return SystemSoundID(1520) // 'Pop' feedback (strong boom)
        case .snare:
            return SystemSoundID(1519) // 'Peek' feedback (weak boom)
        default:
            return nil
        }
    }
}

// MARK: - Extensions

private extension UIColor {
    class var yellow: UIColor {
        return .init(red: 235 / 255.0, green: 201 / 255.0, blue: 62 / 255.0, alpha: 1.0)
    }
}
