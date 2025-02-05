//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

public final class IconButton: UIButton {
    public struct Style {
        let icon: UIImage
        let iconToggled: UIImage

        public init(icon: UIImage, iconToggled: UIImage) {
            self.icon = icon
            self.iconToggled = iconToggled
        }
    }

    private let style: Style

    public var isToggled: Bool = false {
        didSet {
            if isToggled {
                setImage(style.iconToggled, for: .normal)
                accessibilityTraits.insert(.selected)
            } else {
                setImage(style.icon, for: .normal)
                accessibilityTraits.remove(.selected)
            }
        }
    }

    public init(style: Style, withAutoLayout: Bool = false) {
        self.style = style
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setImage(style.icon, for: .normal)
        setImage(style.icon, for: .highlighted)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var isHighlighted: Bool {
        didSet {
            alpha = isHighlighted ? 0.8 : 1
        }
    }
}

public extension IconButton.Style {
    static let favorite = IconButton.Style(icon: .brandFavouriteAddImg,
                                           iconToggled: .brandFavouriteAddedImg)
}
