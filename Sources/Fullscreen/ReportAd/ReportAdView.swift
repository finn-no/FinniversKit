//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class ReportAdView: UIView {
    private let fields = [
        "Mistanke om svindel",
        "Regebrudd",
        "Forhandler opptrer som privat",
    ]

    private lazy var radioButton: RadioButton = {
        let radioButton = RadioButton(strings: fields)
        return radioButton
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    private func setupSubviews() {
        
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
