//
//  Copyright © 2022 FINN AS. All rights reserved.
//

import UIKit

public extension Button.Style {
    static var `sideScrollOption`: Button.Style {
        Button.Style(
            borderWidth: 0,
            stateStyles: [
                .normal: Button.StateStyle(
                    textColor: .stone,
                    backgroundColor: .clear,
                    borderColor: .btnDisabled
                )
                ],
            margins: .zero,
            normalFont: .captionStrong
        )
    }
}

public extension Button {
    
    static func makeSideScrollableButton(withTitle title: String) -> Button {
        let button = Button(style: .sideScrollOption,
                            withAutoLayout: true)
        button.setTitle(title,
                        for: .normal)
        return button
    }
}
