//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

final class PianoKeyView: UIView {
    var isAccidental = false {
        didSet {
            backgroundColor = isAccidental ? UIColor(r: 22, g: 20, b: 23) : .white
        }
    }

    var isSelected = false {
        didSet {
            alpha = isSelected ? 0.8 : 1
        }
    }
}
