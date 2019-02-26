//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class EarthHourDemoView: UIView {
    private lazy var backgrounView = UIView()
    private lazy var earthHourView = EarthHourView(withAutoLayout: true)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) { [weak self] in
            self?.earthHourView.animateBackground()
        }
    }

    // MARK: - Setup

    private func setup() {
        backgrounView.backgroundColor = .black
        earthHourView.model = EarthHourDefaultData()

        addSubview(backgrounView)
        addSubview(earthHourView)

        backgrounView.fillInSuperview()

        NSLayoutConstraint.activate([
            earthHourView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9),
            earthHourView.centerXAnchor.constraint(equalTo: centerXAnchor),
            earthHourView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
