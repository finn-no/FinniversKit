//  Created by Larsen, Truls Benjamin on 10/09/2019.
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public class RadioButtonTableViewCell: UITableViewCell {

    lazy var radioButton: AnimatedRadioButtonView = {
        let radioButton = AnimatedRadioButtonView(frame: .zero)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()

    public func animateSelection(isSelected: Bool) {
        radioButton.animateSelection(selected: isSelected)
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(radioButton)

        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}
