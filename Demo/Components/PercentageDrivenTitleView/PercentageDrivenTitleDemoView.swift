//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class PercentageDrivenTitleDemoView: UIView {

    // MARK: - Private properties

    private lazy var titleView: PercentageDrivenTitleView = {
        let view = PercentageDrivenTitleView(withAutoLayout: true)
        view.title = "Look ma I can hide"
        view.font = UIFont.title3Strong
        view.setPercentageVisible(1)
        return view
    }()

    private lazy var slider: UISlider = {
        let slider = UISlider(withAutoLayout: true)
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.setValue(1, animated: false)
        slider.addTarget(self, action: #selector(sliderDidChange), for: .valueChanged)
        return slider
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Private methods

    private func setup() {
        titleView.layer.borderColor = UIColor.licorice.cgColor
        titleView.layer.borderWidth = 0.5

        addSubview(titleView)
        addSubview(slider)

        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: .largeSpacing),
            titleView.heightAnchor.constraint(equalToConstant: 50),

            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),
            slider.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: .largeSpacing)
        ])
    }

    @objc private func sliderDidChange(_ slider: UISlider) {
        titleView.setPercentageVisible(CGFloat(slider.value))
    }
}
