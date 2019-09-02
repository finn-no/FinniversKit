//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class StepSliderDemoView: UIView {
    private lazy var slider: StepSlider = {
        let slider = StepSlider(numberOfSteps: 10, hasLeftOffset: false, hasRightOffset: false)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(slider)

        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: centerYAnchor),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
