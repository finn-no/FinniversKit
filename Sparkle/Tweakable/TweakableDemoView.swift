//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class TweakableDemoView: UIView, Tweakable {
    lazy public var tweakingOptions: [TweakingOption] = {
        var options = [TweakingOption]()

        options.append(TweakingOption(title: "Option 1", description: nil) { [weak self] in
            self?.titleLabel.text = "Choosen Option 1!\n\nYou can drag the button too :D"
        })

        options.append(TweakingOption(title: "Option 2", description: nil) { [weak self] in
            self?.titleLabel.text = "Choosen Option 2!\n\nYou can drag the button too :D"
        })

        return options
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.text = "Tap the button and choose and option ✨"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(titleLabel)
        titleLabel.fillInSuperview(margin: .largeSpacing)
    }
}
